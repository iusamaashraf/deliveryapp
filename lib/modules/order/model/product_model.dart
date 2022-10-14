import 'dart:convert';

import 'package:equatable/equatable.dart';

class OldProductModel extends Equatable {
  final int id;
  final double offer;
  final double offerPrice;
  final double price;
  final String categoryName;
  final String name;
  final double rating;
  final String image;
  final int totalStock;
  const OldProductModel({
    required this.id,
    required this.offer,
    required this.offerPrice,
    required this.price,
    required this.categoryName,
    required this.name,
    required this.rating,
    required this.image,
    this.totalStock = 5,
  });

  @override
  List<Object> get props {
    return [id, offer, offerPrice, price, categoryName, name, rating, image];
  }

  OldProductModel copyWith({
    int? id,
    double? offer,
    double? offerPrice,
    double? price,
    String? categoryName,
    String? name,
    double? rating,
    String? image,
  }) {
    return OldProductModel(
      id: id ?? this.id,
      offer: offer ?? this.offer,
      offerPrice: offerPrice ?? this.offerPrice,
      price: price ?? this.price,
      categoryName: categoryName ?? this.categoryName,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'offer': offer});
    result.addAll({'offerPrice': offerPrice});
    result.addAll({'price': price});
    result.addAll({'categoryName': categoryName});
    result.addAll({'name': name});
    result.addAll({'rating': rating});
    result.addAll({'image': image});

    return result;
  }

  factory OldProductModel.fromMap(Map<String, dynamic> map) {
    return OldProductModel(
      id: map['id'].toInt() ?? 0,
      offer: map['offer']?.toDouble() ?? 0.0,
      offerPrice: map['offerPrice']?.toDouble() ?? 0.0,
      price: map['price']?.toDouble() ?? 0.0,
      categoryName: map['categoryName'] ?? '',
      name: map['name'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OldProductModel.fromJson(String source) =>
      OldProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(id: $id, offer: $offer, offerPrice: $offerPrice, price: $price, categoryName: $categoryName, name: $name, rating: $rating, image: $image)';
  }
}
