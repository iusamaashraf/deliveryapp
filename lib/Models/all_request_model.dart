import 'package:cloud_firestore/cloud_firestore.dart';

class AllRequestModel {
  String? id;
  String? customer_address;
  String? customer_id;
  String? customer_image;
  GeoPoint? customer_location;
  String? customer_name;
  String? delivery_boy_id;
  String? description;
  double? price;
  String? request_image;
  String? status;
  Timestamp? time;
  bool? isCompleted;
  String? title;
  int? noOfRequest;
  String? tokenId;
  String? pickAddress;
  String? dropAddress;
  GeoPoint? pickupLocation;
  GeoPoint? dropLocation;
  double? distance;
  double? deliveryfee;
  AllRequestModel({
    this.isCompleted,
    this.noOfRequest,
    this.id,
    this.customer_address,
    this.customer_id,
    this.customer_image,
    this.customer_location,
    this.customer_name,
    this.delivery_boy_id,
    this.description,
    this.price,
    this.request_image,
    this.status,
    this.time,
    this.title,
    this.tokenId,
    this.pickAddress,
    this.dropAddress,
    this.pickupLocation,
    this.dropLocation,
    this.distance,
    this.deliveryfee,
  });
  AllRequestModel.fromSnapshot(DocumentSnapshot data) {
    id = data.id;
    isCompleted = data['isComplete'] ?? false;
    noOfRequest = data['no_of_request'] ?? 0;
    customer_address = data['customer_address'] ?? '';
    customer_id = data['customer_id'] ?? '';
    customer_image = data['customer_image'] ?? '';
    customer_location = data['customer_location'] ?? const GeoPoint(0.0, 0.0);
    customer_name = data['customer_name'] ?? '';
    delivery_boy_id = data['delivery_boy_id'] ?? '';
    description = data['description'] ?? '';
    price = data['price'] ?? 0.0;
    request_image = data['request_image'] ?? '';
    status = data['status'] ?? false;
    time = data['time'] ?? Timestamp.now();
    title = data['title'] ?? '';
    pickAddress = data['pickup_address'] ?? '';
    dropAddress = data['drop_address'] ?? '';
    pickupLocation = data['pickup_location'] ?? const GeoPoint(0.0, 0.0);
    dropLocation = data['drop_location'] ?? const GeoPoint(0.0, 0.0);
    distance = data['distance'] ?? 0.0;
    deliveryfee = data['delivery_fee'] ?? 0.0;
    //  / tokenId = data['tokenId'] ?? '';
  }
}
