import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/Controller/push_notification_controller.dart';
import 'package:get/get.dart';
import '../model/notification_model.dart';
import 'single_notification.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({
    Key? key,
    required this.notificationList,
  }) : super(key: key);
  final List<NotificationModel> notificationList;

  @override
  Widget build(BuildContext context) {
    return GetX(builder: (PushNotificationsController notificationController) {
      if (notificationController != null &&
          notificationController.notification != null) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: notificationController.notification!.length,
          itemBuilder: (context, index) {
            final item = notificationController.notification![index];

            return SingleNofitication(
              notification: item,
              color: index == 3 ? const Color(0xffE8F3FF) : null,
            );
          },
        );
        ;
      } else {
        return const Center(child: Text("Loading..."));
      }
    });
  }
}
