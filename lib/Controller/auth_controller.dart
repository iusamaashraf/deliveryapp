import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodbari_deliver_app/Models/delivery_model.dart';
import 'package:foodbari_deliver_app/modules/main_page/main_page.dart';
import 'package:foodbari_deliver_app/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/modules/authentication/authentication_screen.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:get/get.dart';

class AuthController extends GetxController {
  final Rxn<User> _firebaseUser = Rxn<User>();
  User? get user => _firebaseUser.value;
  final firebaseAuth = FirebaseAuth.instance;
  RxInt notifyCounter=0.obs;
  RxString token = ''.obs;
  File? deliveryBoyImage;
  Rxn<DeliveryBoyModel> deliveryBoyModel = Rxn<DeliveryBoyModel>();
  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();
  TextEditingController signUpNameController = TextEditingController();
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();
  var fireStore = FirebaseFirestore.instance;
  RxDouble deliveryBoyLat = 0.0.obs;
  RxDouble deliveryBoyLong = 0.0.obs;
  RxString dBoyAddress = "".obs;
  RxString dBoyPlaceName = "".obs;

  @override
  void onInit() {
    _firebaseUser.bindStream(firebaseAuth.authStateChanges());
    getDeliveryBoyInfo();
    //print("Rx id: ${_firebaseUser.value!.uid}");
    super.onInit();
  }

  Future<void> login(String email, String password, context) async {
    Utils.showLoadingDialog(context, text: "Login in ...");
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Get.offAll(MainPage());
        //  Navigator.popUntil(context, (route) => route.isFirst);
      });
    } catch (e) {
      Get.back();
      Get.snackbar("Alert", e.toString().split("]").last);
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut().then((value) {
      Get.offAll(const AuthenticationScreen());
    });
  }

  Future<void> signUp(
      String email, String password, String name, context) async {
    Utils.showLoadingDialog(context, text: "Registering...");
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((val) async {
        await fireStore.collection("delivery_boy").doc(val.user!.uid).set({
          "name": name,
          "email": email,
          "location": const GeoPoint(0.0, 0.0),
          "phoneNo": "",
          "delivery_boy_address": "",
          "profileImage": ""
        }).then((value) {
          Get.offAll(MainPage());
          //Navigator.popUntil(context, (route) => route.isFirst);
        });
      });
    } catch (e) {
      Get.back();
      Get.snackbar("Alert", e.toString());
    }
  }

  LocationData? currentLocation;
  //final Completer<GoogleMapController> controllerCompleter = Completer();
  GoogleMapController? googleMapController;

  Future getCurrentLocation() async {
    print("Callllled");
    //googleMapController = await controllerCompleter.future;
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    print("services: $_serviceEnabled");

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    print("granted: $_permissionGranted");
    _locationData =
        await location.getLocation().then((loc) => currentLocation = loc);
    print("Current location: $currentLocation");
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        googleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 16.5,
              target: LatLng(newLoc.latitude!, newLoc.longitude!),
            ),
          ),
        );
        Future.delayed(const Duration(seconds: 5), () {
          FirebaseFirestore.instance
              .collection("delivery_boy")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(
                  {'location': GeoPoint(newLoc.latitude!, newLoc.longitude!)});
        });

        // setState(() {});
      },
    );

    deliveryBoyLat.value = _locationData.latitude!;
    deliveryBoyLong.value = _locationData.longitude!;
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        _locationData.latitude!, _locationData.longitude!);
    var shopAddress = placemarks.first;
    dBoyAddress.value = "${shopAddress.subLocality}"
        " ${shopAddress.street}"
        ", ${shopAddress.locality}"
        ", ${shopAddress.subLocality}"
        ", ${shopAddress.subAdministrativeArea}"
        ", ${shopAddress.administrativeArea}"
        ", ${shopAddress.thoroughfare}"
        ", ${shopAddress.country}";
    dBoyPlaceName.value = shopAddress.subLocality!;
    return shopAddress;
  }

  Future<void> updateLocation() async {
    try {
      await fireStore
          .collection("delivery_boy")
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'delivery_boy_address': dBoyAddress.value,
        "location": GeoPoint(deliveryBoyLat.value, deliveryBoyLong.value)
      });
      await getDeliveryBoyInfo();
    } catch (e) {
      //Get.snackbar("Error", e.toString());
      print(e);
    }
  }

  // <<<<<<<<===============forgot account function =================>>>>>>>>
  void forgotPassword(String email) async {
    await firebaseAuth
        .sendPasswordResetEmail(email: email.trim())
        .then((value) {
      Get.snackbar('Link sent succcessfully',
          'Please check your email to reset password');
      Get.to(() => const AuthenticationScreen());
    });
  }

  Future<DeliveryBoyModel> getDeliveryBoyInfo() async {
    var userData = await fireStore
        .collection("delivery_boy")
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    deliveryBoyModel.value = DeliveryBoyModel.fromSnapshot(userData);
    return DeliveryBoyModel.fromSnapshot(userData);
  }

  void updateProfile({
    required String name,
    required String phone,
    required context,
  }) async {
    Utils.showLoadingDialog(context, text: "Updating profile...");
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('delivery-boy-image')
          .child(firebaseAuth.currentUser!.uid);
      await ref.putFile(deliveryBoyImage!);
      final url = await ref.getDownloadURL();
      Map<String, dynamic> userInfo = {
        'phoneNo': phone,
        'name': name,
        'profileImage': url,
      };
      await fireStore
          .collection('delivery_boy')
          .doc(firebaseAuth.currentUser!.uid)
          .update(userInfo);
      await getDeliveryBoyInfo();
      Get.back();
      Get.snackbar("Success", "Profile updated");
    } catch (e) {
      Get.back();
      Get.snackbar("Alert", e.toString().split("]").last);
    }
  }
}
