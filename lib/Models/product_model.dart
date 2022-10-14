import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? productId;
  String? productName;
  String? productImage;
  double? productPrice;
  bool? isPurchase;
  String? status;
  String? riderId;
  ProductModel({
    this.isPurchase,
    this.productId,
    this.productImage,
    this.productName,
    this.productPrice,
    this.status,
    this.riderId
  });
  ProductModel.fromSnapshot(DocumentSnapshot data) {
    isPurchase = data['is_purchase']??false;
    productPrice = data['product_price'] ?? 0.0;
    productId = data['product_id'] ?? '';
    productImage = data['product_image'] ?? '';
    productName = data['product_name'] ?? '';
    status = data['status'] ?? "";
    riderId=data['rider_id']??"";
  }
}