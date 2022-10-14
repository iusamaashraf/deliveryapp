import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../Models/product_model.dart';

class ProductController extends GetxController{
  Rxn<List<ProductModel>> productList = Rxn<List<ProductModel>>();
  List<ProductModel>? get product => productList.value;
var firstore =FirebaseFirestore.instance;
  @override
  void onInit() {
    productList.bindStream(allProductStream());
    super.onInit();
  }

  Stream<List<ProductModel>> allProductStream() {
    print("enter in all product stream funtion");
    return firstore
        .collection('products')
        .snapshots()
        .map((QuerySnapshot query) {
      List<ProductModel> retVal = [];

      query.docs.forEach((element) {

        retVal.add(ProductModel.fromSnapshot(element));
      });

      print('products lenght is ${retVal.length}');
      return retVal;
    });
  }
}