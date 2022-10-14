import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodbari_deliver_app/Controller/auth_controller.dart';
import 'package:foodbari_deliver_app/Controller/push_notification_controller.dart';
import 'package:foodbari_deliver_app/Models/distance_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Models/all_request_model.dart';

class RequestController extends GetxController {
  Rxn<List<AllRequestModel>> offerList = Rxn<List<AllRequestModel>>();
  List<AllRequestModel>? get offers => offerList.value;
  final AuthController auth = Get.find<AuthController>();
  final _firestore = FirebaseFirestore.instance;
  @override
  void onInit() {
    offerList.bindStream(receiveOfferStream());
    super.onInit();
  }

  Stream<List<AllRequestModel>> receiveOfferStream() {
    print("receive offer stream funtion");
    return _firestore
        .collection('all_requests')
        .where("delivery_boy_id", isEqualTo: "")
        .where("status", isEqualTo: "")
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllRequestModel> retVal = [];

      for (var element in query.docs) {
        retVal.add(AllRequestModel.fromSnapshot(element));
      }

      debugPrint('offer receive  lenght is ${retVal.length}');
      return retVal;
    });
  }

  Future<void> sentOffer(
      {String? offerId, int? noOfRequest, context, String? customerID}) async {
    try {
      await _firestore.collection('all_requests').doc(offerId).update({
        "status": "Pending",
        "no_of_request": noOfRequest! + 1,
      }).then((value) async {
        print("hello there $offerId ");
        await _firestore
            .collection('all_requests')
            .doc(offerId)
            .collection("received_offer")
            .add({
          "offer_id": offerId,
          "delivery_boy_id": auth.deliveryBoyModel.value!.id,
          "name": auth.deliveryBoyModel.value!.name,
          "address": auth.deliveryBoyModel.value!.address,
          "location": auth.deliveryBoyModel.value!.location,
          "phone": auth.deliveryBoyModel.value!.phone,
          "image": auth.deliveryBoyModel.value!.profileImage == ""
              ? "https://cdn.techjuice.pk/wp-content/uploads/2015/02/wallpaper-for-facebook-profile-photo-1024x645.jpg"
              : auth.deliveryBoyModel.value!.profileImage,
          "email": auth.deliveryBoyModel.value!.email,
        }).then((val) async {
          //PUSH NOTIFICATION
          await FirebaseFirestore.instance
              .collection("CustomerTokens")
              .doc(customerID)
              .get()
              .then((value) async {
            Get.find<PushNotificationsController>().sendPushMessage(
                value.get("Token"),
                "You recieved an offer from ${auth.deliveryBoyModel.value!.name}",
                "Offer Recieved");
            await FirebaseFirestore.instance
                .collection("Customer")
                .doc(customerID)
                .collection("Notifications")
                .add({
              "Title": "Offer Recieved",
              "Body":
                  "You recieved an offer from ${auth.deliveryBoyModel.value!.name}",
              "Date": DateTime.now().toString(),
              "Seen": false,
            });
          });
        });
        Get.snackbar("Success", "Offer sent...");
      });
    } catch (e) {
      Get.snackbar("Alert", e.toString());
      print("error is here $e");
    }
  }

  Rxn<Distancemodels> distanceModel = Rxn<Distancemodels>();
  distance({pickLat, pickLng, dropLat, dropLng}) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${pickLat},${pickLng}&destinations=${dropLat},${dropLng}&key=AIzaSyAzr66eCsT-AfdfVw5zoFG0guIHFOeIDr0'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var distances = await response.stream.bytesToString();
      Map<String, dynamic> map = jsonDecode(distances);
      distanceModel.value = Distancemodels.fromJson(map);
    } else {
      print(response.reasonPhrase);
    }
  }
}
