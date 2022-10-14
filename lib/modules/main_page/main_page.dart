import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/Controller/auth_controller.dart';
import 'package:foodbari_deliver_app/Controller/push_notification_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;

import '../message/chat_list_screen.dart';
import '../order/order_screen.dart';
import '../order_history/order_history_screen.dart';
import '../profile/profile_screen.dart';
import 'component/bottom_navigation_bar.dart';
import 'main_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _homeController = MainController();
  final authController = Get.find<AuthController>();

  late List<Widget> pageList;
  fcm.FirebaseMessaging _fcm = fcm.FirebaseMessaging.instance;

  generatingTokenForUser() async {
    //GENERATING A TOKEN FROM FIREBASE MESSAGING
    final fcmToken = await _fcm.getToken();
    //GETTING CURRENTUSER ID
    final uid = Get.find<AuthController>().user?.uid ?? "Null";
    print("This is the user $uid");
    await FirebaseFirestore.instance
        .collection("DeliveryBoyTokens")
        .doc(uid)
        .set({
      "CreatedAt": FieldValue.serverTimestamp(),
      "Token": fcmToken,
      "UID": uid
    }).then((value) {
      print("Token successfully");
    });
  }

  Future<void> getTokenId() async {
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(Get.find<AuthController>().user?.uid)
        .get()
        .then((value) async {
      Get.find<AuthController>().token.value = await value.data()!['Token'];
      print("token is here  : ${Get.find<AuthController>().token.value}");
    });
  }

  @override
  void initState() {
    super.initState();
    Get.put(PushNotificationsController());
    generatingTokenForUser();
    // getTokenId();
    authController.getDeliveryBoyInfo();
    authController.getCurrentLocation().then((value) async {
      Future.delayed(const Duration(minutes: 5), () async {
        await authController.updateLocation();
      });
    });
    unseenNotificationsQuery();

    pageList = [
      const OrderHistoryScreen(),
      const OrderScreen(),
      ProfileScreen(),
    ];
  }

  unseenNotificationsQuery() async {
    await FirebaseFirestore.instance
        .collection("delivery_boy")
        .doc(Get.find<AuthController>().user?.uid)
        .collection("Notifications")
        .where("Seen", isEqualTo: false)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        Get.find<AuthController>().notifyCounter =
            Get.find<AuthController>().notifyCounter + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      //  key: _homeController.scaffoldKey,
      // drawer: const DrawerWidget(),
      body: StreamBuilder<int>(
        initialData: 0,
        stream: _homeController.naveListener.stream,
        builder: (context, AsyncSnapshot<int> snapshot) {
          int index = snapshot.data ?? 0;
          return pageList[index];
        },
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
