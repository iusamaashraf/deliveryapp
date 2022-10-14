import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsModel {
  String? body;
  String? date;
  bool? seen;
  String? title;
  NotificationsModel({this.body, this.date, this.seen, this.title});
  NotificationsModel.fromSnapshot(DocumentSnapshot snapshot) {
    body = snapshot['Body'] ?? "";
    date = snapshot['Date'] ?? "";
    seen = snapshot['Seen'] ?? false;
    title = snapshot['Title'] ?? "";
  }
}
