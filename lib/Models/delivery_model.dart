import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryBoyModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  GeoPoint? location;
  String? address;
  String? profileImage;
  DeliveryBoyModel({
    this.address,
    this.id,
    this.name,
    this.email,
    this.phone,
    this.location,
    this.profileImage,
  });
  DeliveryBoyModel.fromSnapshot(DocumentSnapshot data) {
    id = data.id;
    name = data['name'] ?? '';
    email = data['email'] ?? '';
    phone = data['phoneNo'] ?? '';
    location = data['location'] ?? '';
    address = data['delivery_boy_address'] ?? '';
    profileImage = data['profileImage'] ?? '';
  }
}
