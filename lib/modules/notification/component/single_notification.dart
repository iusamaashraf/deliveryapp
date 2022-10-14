import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/Models/notifications_model.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_image.dart';
import '../model/notification_model.dart';

class SingleNofitication extends StatelessWidget {
  const SingleNofitication({
    Key? key,
    required this.notification,
    this.color,
  }) : super(key: key);
  final NotificationsModel notification;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(notification.title!),
            subtitle: Text(notification.body!),
            trailing: Text(notification.date!.split(" ").last.split(".").first),
          ),
        ));
  }

  // Widget _buildImageCirculer(NotificationsModel item) {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(30),
  //     child: CustomImage(
  //       height: 55,
  //       width: 55,
  //       path: item.image,
  //       fit: BoxFit.contain,
  //     ),
  //   );
  // }
}
