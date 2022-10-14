import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodbari_deliver_app/Controller/auth_controller.dart';
import 'package:foodbari_deliver_app/Models/notifications_model.dart';
import 'package:foodbari_deliver_app/modules/notification/model/notification_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PushNotificationsController extends GetxController {
  Rxn<List<NotificationsModel>> notificationList =
      Rxn<List<NotificationsModel>>();
  List<NotificationsModel>? get notification => notificationList.value;
  @override
  void onInit() {
    notificationList.bindStream(allNotificationStream());
    super.onInit();
  }

  Stream<List<NotificationsModel>> allNotificationStream() {
    print("enter in all product stream funtion");
    return FirebaseFirestore.instance
        .collection('delivery_boy')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Notifications")
        .snapshots()
        .map((QuerySnapshot query) {
      List<NotificationsModel> retVal = [];

      for (var element in query.docs) {
        retVal.add(NotificationsModel.fromSnapshot(element));
      }

      print('Notification lenght is ${retVal.length}');
      return retVal;
    });
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      //POST METHOD FOR PUSH NOTIFICATIONS (FIREBASE CLOUD MESSAGING)
      //THE AUTHORIZATION KEY IS FROM FIREBASE CLOUD MESSAGING SECTION (SERVER KEY)
      await http
          .post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAbGoDln4:APA91bGnMAHcvd4N9Ozs3A2vqv66a20ATyNXGddjIvoPvi519D8LCAmkEWQNJQL7vOpFp61PNyjuReIpq5yJHihnH6Bn57OvzJvBXiDkz6WhFyixc6RrFdtl8wVep8wnLmrNzdJvx3iz',
        },
        //IT IS GIVING THE NOTIFICATION THE BODY AND TITLE
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'sound': true
            },
            //TOKEN IS UNIQUE FOR EVERY USER DEVICE THROUGH WHICH THE NOTIFICATION COMES
            "to": token,
          },
        ),
      )
          .then((value) {
        print("Successfully Send ${value.body}");
      });
    } catch (e) {
      print("error push notification");
    }
  }

  void sendPushImageMessage(
      String token, String body, String title, String? image) async {
    try {
      //POST METHOD FOR PUSH NOTIFICATIONS (FIREBASE CLOUD MESSAGING)
      //THE AUTHORIZATION KEY IS FROM FIREBASE CLOUD MESSAGING SECTION (SERVER KEY)
      await http
          .post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAdCc8tSI:APA91bHc-zU6VHnBwpACLAynUue5dIraDtkeC4UrKg_DmvViLAwgnKgOgQ5WXozAa6hiYEdISUomZ2qqpRjXzYU6FiCEjSIOAI8EIFN6FN_36B2p_tv1KNoJ54E6zc39COTx78Bm__9M',
        },
        //IT IS GIVING THE NOTIFICATION THE BODY AND TITLE
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              "image": image,
              "sound": "notification.mp3"
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'sound': true
            },
            //TOKEN IS UNIQUE FOR EVERY USER DEVICE THROUGH WHICH THE NOTIFICATION COMES
            "to": token,
          },
        ),
      )
          .then((value) {
        print("Successfully Send ${value.body}");
      });
    } catch (e) {
      print("error push notification");
    }
  }

  //SEND LIKE NOTIFICATION
  Future<void> sendLikeNotification(
      String receiverUID,
      String senderName,
      String senderImage,
      String imgURL,
      bool isTrainer,
      String postTitle) async {
    String notifyBody = "$senderName liked your post";
    if (receiverUID != Get.find<AuthController>().user!.uid) {
      if (isTrainer) {
        //IF THE POST UPLOADER IS TRAINER
        await FirebaseFirestore.instance
            .collection("Trainers")
            .doc(receiverUID)
            .collection("Notifications")
            .add({
          "Body": notifyBody,
          "View": false,
          "SenderName": senderName,
          "SenderImage": senderImage,
          "PostImage": imgURL,
          "PostTitle": postTitle,
          "Date": DateTime.now().toString()
        }).then((value) {
          FirebaseFirestore.instance
              .collection("Trainers")
              .doc(receiverUID)
              .get()
              .then((value) => sendPushImageMessage(
                  value["FCMtoken"], notifyBody, "BBM fitness", imgURL));
        });
      } else {
        //IF THE POST UPLOADER IS USER

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(receiverUID)
            .collection("Notifications")
            .add({
          "Body": notifyBody,
          "SenderName": senderName,
          "View": false,
          "SenderImage": senderImage,
          "PostImage": imgURL,
          "PostTitle": postTitle,
          "Date": DateTime.now().toString()
        }).then((value) {
          FirebaseFirestore.instance
              .collection("UserTokens")
              .where("UID", isEqualTo: receiverUID)
              .get()
              .then((value) => sendPushImageMessage(
                  value.docs[0]["Token"], notifyBody, "BBM fitness", imgURL));
        });
      }
    } else {
      print("Your own post");
    }
  }

  //SEND COMMENT NOTIFICATIOn
  Future<void> sendCommentNotification(
      String receiverUID,
      String senderName,
      String senderImage,
      String imgURL,
      bool isTrainer,
      String postTitle) async {
    String notifyBody = "$senderName commented on your post";
    if (receiverUID != Get.find<AuthController>().user!.uid) {
      if (isTrainer) {
        //IF THE POST UPLOADER IS TRAINER
        await FirebaseFirestore.instance
            .collection("Trainers")
            .doc(receiverUID)
            .collection("Notifications")
            .add({
          "Body": notifyBody,
          "SenderName": senderName,
          "SenderImage": senderImage,
          "PostImage": imgURL,
          "PostTitle": postTitle,
          "Date": DateTime.now().toString()
        }).then((value) {
          FirebaseFirestore.instance
              .collection("Trainers")
              .doc(receiverUID)
              .get()
              .then((value) => sendPushImageMessage(
                  value["FCMtoken"], notifyBody, "BBM fitness", imgURL));
        });
      } else {
        //IF THE POST UPLOADER IS USER
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(receiverUID)
            .collection("Notifications")
            .add({
          "Body": notifyBody,
          "SenderName": senderName,
          "SenderImage": senderImage,
          "PostImage": imgURL,
          "PostTitle": postTitle,
          "Date": DateTime.now().toString()
        }).then((value) {
          FirebaseFirestore.instance
              .collection("UserTokens")
              .where("UID", isEqualTo: receiverUID)
              .get()
              .then((value) => sendPushImageMessage(
                  value.docs[0]["Token"], notifyBody, "BBM fitness", imgURL));
        });
      }
    } else {
      print("Your own post");
    }
  }
}
