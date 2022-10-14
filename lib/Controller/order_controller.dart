import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodbari_deliver_app/Controller/auth_controller.dart';
import 'package:foodbari_deliver_app/Models/all_request_model.dart';
import 'package:foodbari_deliver_app/Models/product_model.dart';
import 'package:foodbari_deliver_app/utils/utils.dart';
import 'package:get/get.dart';
import '../Models/customer_model.dart';

class OrderController extends GetxController {
  Rxn<List<CustomerModel>> customerList = Rxn<List<CustomerModel>>();
  List<CustomerModel>? get customer => customerList.value;

  Rxn<List<ProductModel>> customerProductList = Rxn<List<ProductModel>>();
  List<ProductModel>? get customerProducts => customerProductList.value;

  //complete order
  Rxn<List<AllRequestModel>> orderStatusList = Rxn<List<AllRequestModel>>();
  List<AllRequestModel>? get orderStatus => orderStatusList.value;

  var firstore = FirebaseFirestore.instance;
  @override
  void onInit() {
    customerList.bindStream(allCustomer());
    super.onInit();
  }

  void getOrderStatus(String status) {
    orderStatusList.bindStream(orderStatusScreen(status));
    super.onInit();
  }

  Stream<List<AllRequestModel>> orderStatusScreen(String status) {
    return firstore
        .collection('all_requests')
        .where("delivery_boy_id",
            isEqualTo: Get.find<AuthController>().user!.uid)
        .where("status", isEqualTo: status)
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllRequestModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(AllRequestModel.fromSnapshot(element));
      }
      print('status lenght is ${retVal.length}');
      return retVal;
    });
  }

  void getOrderPendingStatus() {
    orderStatusList.bindStream(orderStatusPending());
    super.onInit();
  }

  Stream<List<AllRequestModel>> orderStatusPending() {
    return firstore
        .collection('all_requests')
        .where("status", isEqualTo: "Pending")
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllRequestModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(AllRequestModel.fromSnapshot(element));
      }
      print('status lenght is pending ${retVal.length}');
      return retVal;
    });
  }

  void getCustomerProduct(String id) {
    customerProductList.bindStream(allCustomerProducts(id));
  }

  Rxn<AllRequestModel> currentOrder = Rxn<AllRequestModel>();
  Future<void> getCurrentOrder(String id) async {
    var a = await firstore.collection("all_requests").doc(id).get();
    currentOrder.value = AllRequestModel.fromSnapshot(a);
  }

  // Stream<List<ProductModel>> currentRequest(id) {
  //   return firstore.collection('all_requests').doc(id).snapshots().map((query) {
  //     print("here is query");
  //     List<ProductModel> retVal = [];
  //     for (var element in query.docs) {
  //       retVal.add(ProductModel.fromSnapshot(element));
  //     }
  //     print('customer product lenght is ${retVal.length}');
  //     return retVal;
  //   });
  // }

  Stream<List<ProductModel>> allCustomerProducts(id) {
    return firstore
        .collection('orders')
        .doc(id)
        .collection("products_order")
        .snapshots()
        .map((query) {
      print("here is query");
      List<ProductModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(ProductModel.fromSnapshot(element));
      }
      print('customer product lenght is ${retVal.length}');
      return retVal;
    });
  }

  Stream<List<CustomerModel>> allCustomer() {
    print("my Customer stream funtion");
    return firstore
        .collection('orders')
        .where("status", isEqualTo: "")
        .snapshots()
        .map((QuerySnapshot query) {
      List<CustomerModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(CustomerModel.fromSnapshot(element));
      }
      print('order lenght is ${retVal.length}');
      return retVal;
    });
  }

  Future<void> acceptOrder(AllRequestModel customerModel, context) async {
    Utils.showLoadingDialog(context, text: "Accepting order...");
    try {
      var authController = Get.find<AuthController>();
      await firstore.collection("orders").doc(customerModel.id).update({
        "status": "On the way",
        "delivery_boy_id": FirebaseAuth.instance.currentUser!.uid
      }).then((value) async {
        // await firstore
        //     .collection("delivery_boy")
        //     .doc(FirebaseAuth.instance.currentUser!.uid)
        //     .collection("my_orders_accepted")
        //     .add({
        //   "name": customerModel.customer_name,
        //   "delivery_boy_id": customerModel.delivery_boy_id,
        //   "email": customerModel.,
        //   "location": customerModel.location,
        //   "address": customerModel.address,
        //   "profileImage": customerModel.profileImage,
        //   "time": customerModel.time,
        // }).then((value) async {
        //   for (int i = 0; i < customerProducts!.length; i++) {
        //     await firstore
        //         .collection("delivery_boy")
        //         .doc(FirebaseAuth.instance.currentUser!.uid)
        //         .collection("my_orders_accepted")
        //         .doc(value.id)
        //         .collection("products")
        //         .doc(customerProducts![i].productId)
        //         .set({
        //       "product_id": customerProducts![i].productId,
        //       "prduct_image": customerProducts![i].productImage,
        //       "product_price": customerProducts![i].productPrice,
        //       "product_name": customerProducts![i].productName,
        //       "is_purchased": customerProducts![i].isPurchase,
        //     });
        //   }
        // });
        // await authController.getDeliveryBoyInfo();
        // await firstore
        //     .collection("Customer")
        //     .doc(customerModel.customerId)
        //     .collection("accepted_order")
        //     .add({
        //   "rider_name": authController.deliveryBoyModel.value!.name,
        //   "rider_email": authController.deliveryBoyModel.value!.email,
        //   "rider_phone": authController.deliveryBoyModel.value!.phone,
        //   "rider_address": authController.deliveryBoyModel.value!.address,
        //   "rider_location": authController.deliveryBoyModel.value!.location,
        // }).then((value) async {
        //   for (int i = 0; i < customerProducts!.length; i++) {
        //     await firstore
        //         .collection("Customer")
        //         .doc(customerModel.customerId)
        //         .collection("accepted_order")
        //         .doc(value.id)
        //         .collection("accepted_order_products")
        //         .doc(customerProducts![i].productId)
        //         .set({
        //       "product_id": customerProducts![i].productId,
        //       "prduct_image": customerProducts![i].productImage,
        //       "product_price": customerProducts![i].productPrice,
        //       "product_name": customerProducts![i].productName,
        //       "is_purchased": customerProducts![i].isPurchase,
        //     }).then((value) {
        //       Get.back();
        //       Utils.showCustomDialog(context,
        //           child: Padding(
        //             padding: const EdgeInsets.all(12.0),
        //             child: SizedBox(
        //               height: 100,
        //               child: Column(
        //                 children: [
        //                   const Icon(
        //                     CupertinoIcons.checkmark_circle_fill,
        //                     color: Colors.green,
        //                   ),
        //                   const Text("Order Accepted"),
        //                   TextButton(
        //                       onPressed: () {
        //                         Get.back();
        //                       },
        //                       child: const Text("Ok"))
        //                 ],
        //               ),
        //             ),
        //           ));
        //     });
        //   }
        // });
      });
    } catch (e) {
      Get.back();
      Get.snackbar("Alert", e.toString().split("]").last);
    }
  }

  Rxn<CustomerModel> customerModel = Rxn<CustomerModel>();

  Future<void> getCutomerDetails(String id) async {
    var doc = await firstore.collection("Customer").doc(id).get();
    customerModel.value = CustomerModel.fromSnapshot(doc);
  }

  Future<void> requestForComplete(String id) async {
    await firstore.collection("all_requests").doc(id).update({
      "isComplete": true,
    });
  }

  // <=============================== Getting active orders ==============================>
  void activeFunc() {
    activeList.bindStream(showingActiveStatus());
  }

  Rxn<List<AllRequestModel>> activeList = Rxn<List<AllRequestModel>>();
  List<AllRequestModel>? get active => activeList.value;
  Stream<List<AllRequestModel>> showingActiveStatus() {
    //print('Object: ${AuthController.auth!.uid}');
    return FirebaseFirestore.instance
        .collection('all_requests')
        .where("delivery_boy_id",
            isEqualTo: Get.find<AuthController>().user!.uid)
        .where("status", isEqualTo: 'On the way')
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllRequestModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(AllRequestModel.fromSnapshot(element));
      }
      print("aa length is${retVal.length.toString()}");
      return retVal;
    });
  }

  // <=============================== Getting pending orders ==============================>
  void pendingFunc() {
    pendingList.bindStream(showingPendingStatus());
  }

  Rxn<List<AllRequestModel>> pendingList = Rxn<List<AllRequestModel>>();
  List<AllRequestModel>? get pending => pendingList.value;
  Stream<List<AllRequestModel>> showingPendingStatus() {
    return FirebaseFirestore.instance
        .collection('all_requests')
        .where("delivery_boy_id",
            isEqualTo: Get.find<AuthController>().user!.uid)
        .where("status", isEqualTo: 'Pending')
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllRequestModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(AllRequestModel.fromSnapshot(element));
      }
      print("aa length is${retVal.length.toString()}");
      return retVal;
    });
  }

  // <=============================== Getting completed orders ==============================>
  void completedFunc() {
    compList.bindStream(showingCompletedStatus());
  }

  Rxn<List<AllRequestModel>> compList = Rxn<List<AllRequestModel>>();
  List<AllRequestModel>? get compl => compList.value;
  Stream<List<AllRequestModel>> showingCompletedStatus() {
    return FirebaseFirestore.instance
        .collection('all_requests')
        .where("delivery_boy_id",
            isEqualTo: Get.find<AuthController>().user!.uid)
        .where("status", isEqualTo: 'Completed')
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllRequestModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(AllRequestModel.fromSnapshot(element));
      }
      print("comple length is${retVal.length.toString()}");
      return retVal;
    });
  }

  // <=============================== Getting cancelled orders ==============================>
  void cancelledFunc() {
    cancelList.bindStream(showingCancelledStatus());
  }

  Rxn<List<AllRequestModel>> cancelList = Rxn<List<AllRequestModel>>();
  List<AllRequestModel>? get cancel => cancelList.value;
  Stream<List<AllRequestModel>> showingCancelledStatus() {
    return FirebaseFirestore.instance
        .collection('all_requests')
        .where("delivery_boy_id",
            isEqualTo: Get.find<AuthController>().user!.uid)
        .where("status", isEqualTo: 'Cancelled')
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllRequestModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(AllRequestModel.fromSnapshot(element));
      }
      print("comple length is${retVal.length.toString()}");
      return retVal;
    });
  }

  calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
