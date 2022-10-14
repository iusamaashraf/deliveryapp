import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/Controller/order_controller.dart';
import 'package:foodbari_deliver_app/Controller/push_notification_controller.dart';
import 'package:foodbari_deliver_app/map_screen.dart';
import 'package:foodbari_deliver_app/utils/utils.dart';
import 'package:foodbari_deliver_app/widgets/primary_button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants.dart';
import 'component/order_app_bar.dart';
import 'model/product_order_model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List<OrderedProductModel> _productList = [];
  int initialLabelIndex = 0;
  final OrderController orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    //  Get.put(ProductController());
    // Get.put(RequestController());
    orderController.activeFunc();
    orderController.pendingFunc();
    orderController.completedFunc();
    orderController.cancelledFunc();
    orderController.getOrderStatus("Completed");
    setState(() {});
    authController.getCurrentLocation();
    setState(() {});
    //  initialLabelIndex = widget.initialLabelIndex;
    // textList = widget.textList;
    // _filtering(0);
  }

  Widget _buildSingleBtn(int key, String value) {
    return Flexible(
      // flex: 1,
      fit: FlexFit.tight,
      child: InkWell(
        onTap: () => setState(() {
          initialLabelIndex = key;
          if (value == "Pending") {
            orderController.getOrderPendingStatus();
          } else {
            orderController.getOrderStatus(value);
          }

          print("index is here : $initialLabelIndex");
          // widget.onChange(initialLabelIndex);
        }),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: initialLabelIndex == key ? redColor : Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FittedBox(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: initialLabelIndex != key ? blackColor : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void _filtering(int index) {
  //   String filter = 'cancelled';
  //   _productList.clear();

  //   if (index == 0) {
  //     filter = 'delivered';
  //   } else if (index == 1) {
  //     filter = 'processing';
  //   }

  //   for (var element in orderProductList) {
  //     if (element.status.toLowerCase() == filter) {
  //       _productList.add(element);
  //     }
  //   }
  //   setState(() {});
  // }

  final list = [
    'Completed',
    'Pending',
    'On the way',
    'Cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    const double appBarHeight = 174;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: size.height,
      width: size.width,
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          OrderAppBar(height: appBarHeight),
          Container(
            height: 36,
            //s  width: 120,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSingleBtn(0, list[0]),
                _buildSingleBtn(1, list[1]),
                _buildSingleBtn(2, list[2]),
                _buildSingleBtn(3, list[3])
              ],
            ),
          ),
          Expanded(child:
              GetX<OrderController>(builder: (OrderController orderController) {
            if (orderController.orderStatus == null ||
                orderController.orderStatus!.isEmpty) {
              return const Center(
                child: Text("No order found"),
              );
            } else {
              return ListView.builder(
                  // physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 55),
                  shrinkWrap: true,
                  itemCount: orderController.orderStatus!.length,
                  itemBuilder: (context, index) {
                    var orderStatus = orderController.orderStatus![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(12),
                        // height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //_buildProductHeader(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Order Date',
                                      style:
                                          TextStyle(height: 1, color: redColor),
                                    ),

                                    SizedBox(height: 8),
                                    // InVoiceWidget(text: orderStatus.invoice),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      Utils.formatDate(
                                          orderStatus.time!.toDate()),
                                      style: const TextStyle(
                                          height: 1, color: paragraphColor),
                                    ),
                                    const SizedBox(height: 1),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: Get.width * 0.6,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Title: ",
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                height: 1,
                                                color: Colors.grey),
                                          ),
                                          Flexible(
                                            child: Text(
                                              orderStatus.title.toString(),
                                              style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  height: 1,
                                                  color: redColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: Get.width * 0.6,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Description: ",
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                height: 1,
                                                color: Colors.grey),
                                          ),
                                          Flexible(
                                            child: Text(
                                              orderStatus.description
                                                  .toString(),
                                              style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  height: 1,
                                                  color: redColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: Get.width * 0.6,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Price: ",
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                height: 1,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            "\$ ${orderStatus.price.toString()}",
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                height: 1,
                                                color: redColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    orderStatus.request_image != ""
                                        ? CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                orderStatus.customer_image!),
                                          )
                                        : const CircleAvatar(
                                            radius: 25,
                                            backgroundImage: AssetImage(
                                                "assets/images/profile.jpg")),
                                    const SizedBox(height: 1),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),

                            const SizedBox(height: 14),

                            initialLabelIndex == 1
                                ? const SizedBox()
                                : orderStatus.isCompleted == true
                                    ? const ElevatedButton(
                                        onPressed: null,
                                        child: Text(
                                            "Wait for confirm from customer"))
                                    : PrimaryButton(
                                        text: initialLabelIndex == 2
                                            ? "Got the package"
                                            : "View Detail",
                                        onPressed: () async {
                                          //PUSH NOTIFICATION
                                          await FirebaseFirestore.instance
                                              .collection("CustomerTokens")
                                              .doc(orderStatus.customer_id!)
                                              .get()
                                              .then((value) async {
                                            Get.find<
                                                    PushNotificationsController>()
                                                .sendPushMessage(
                                                    value.get("Token"),
                                                    "The delivery boy got the package",
                                                    "Package Got!");
                                            await FirebaseFirestore.instance
                                                .collection("Customer")
                                                .doc(orderStatus.customer_id!)
                                                .collection("Notifications")
                                                .add({
                                              "Title": "Package Got!",
                                              "Body":
                                                  "The delivery boy got the package",
                                              "Date": DateTime.now().toString(),
                                              "Seen":      false,
                                            });
                                          });
                                          await orderController
                                              .getCutomerDetails(
                                                  orderStatus.customer_id!)
                                              .then((value) {
                                            Get.bottomSheet(
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                    vertical:
                                                        Get.height * 0.05),
                                                child: Container(
                                                  // padding:
                                                  //     EdgeInsets.all(16),
                                                  height: Get.height * 0.37,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 25,
                                                              backgroundImage: orderController
                                                                          .customerModel
                                                                          .value!
                                                                          .profileImage !=
                                                                      ""
                                                                  ? NetworkImage(
                                                                      orderController
                                                                          .customerModel
                                                                          .value!
                                                                          .profileImage!)
                                                                  : const NetworkImage(
                                                                      "https://cdn.techjuice.pk/wp-content/uploads/2015/02/wallpaper-for-facebook-profile-photo-1024x645.jpg"),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  orderController
                                                                      .customerModel
                                                                      .value!
                                                                      .name!,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .subtitle1!
                                                                      .copyWith(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                ),
                                                                Text(
                                                                  orderController
                                                                      .customerModel
                                                                      .value!
                                                                      .phone!,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .caption!
                                                                      .copyWith(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Email : ",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .caption!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                            ),
                                                            Text(
                                                              orderController
                                                                  .customerModel
                                                                  .value!
                                                                  .email!,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .caption!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          'Full Address State to State',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .caption!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            orderController
                                                                .customerModel
                                                                .value!
                                                                .address!,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption!
                                                                .copyWith(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Row(
                                                          children: [
                                                            Text('See on map'),
                                                            IconButton(
                                                                onPressed: () {
                                                                  requestController
                                                                      .distance(
                                                                    pickLat: orderController
                                                                        .orderStatus![
                                                                            index]
                                                                        .pickupLocation!
                                                                        .latitude,
                                                                    pickLng: orderController
                                                                        .orderStatus![
                                                                            index]
                                                                        .pickupLocation!
                                                                        .longitude,
                                                                    dropLat: orderController
                                                                        .orderStatus![
                                                                            index]
                                                                        .dropLocation!
                                                                        .latitude,
                                                                    dropLng: orderController
                                                                        .orderStatus![
                                                                            index]
                                                                        .dropLocation!
                                                                        .longitude,
                                                                  );
                                                                  Get.to(() =>
                                                                      MapScreen(
                                                                        orderId: orderController
                                                                            .orderStatus![index]
                                                                            .id!,
                                                                        dropLat: orderController
                                                                            .orderStatus![index]
                                                                            .pickupLocation!
                                                                            .latitude,
                                                                        dropLng: orderController
                                                                            .orderStatus![index]
                                                                            .dropLocation!
                                                                            .longitude,
                                                                        pickLat: orderController
                                                                            .orderStatus![index]
                                                                            .pickupLocation!
                                                                            .latitude,
                                                                        pickLng: orderController
                                                                            .orderStatus![index]
                                                                            .pickupLocation!
                                                                            .longitude,
                                                                        // destinationLat: orderController
                                                                        //     .customerModel
                                                                        //     .value!
                                                                        //     .location!
                                                                        //     .latitude,
                                                                        // destinationLng: orderController
                                                                        //     .customerModel
                                                                        //     .value!
                                                                        //     .location!
                                                                        //     .longitude)
                                                                      ));
                                                                },
                                                                icon: Icon(
                                                                    Icons.map))
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        const Spacer(),
                                                        initialLabelIndex == 2
                                                            ? PrimaryButton(
                                                                text:
                                                                    "Package delivered",
                                                                onPressed:
                                                                    () async {
                                                                  //PUSH NOTIFICATION
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "CustomerTokens")
                                                                      .doc(orderStatus
                                                                          .customer_id!)
                                                                      .get()
                                                                      .then(
                                                                          (value) async {
                                                                    Get.find<PushNotificationsController>().sendPushMessage(
                                                                        value.get(
                                                                            "Token"),
                                                                        "Go and verify through the app",
                                                                        "Package Delivered!");
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "Customer")
                                                                        .doc(orderStatus
                                                                            .customer_id!)
                                                                        .collection(
                                                                            "Notifications")
                                                                        .add({
                                                                      "Title":
                                                                          "Package Delivered!",
                                                                      "Body":
                                                                          "Go and verify through the app",
                                                                      "Date": DateTime
                                                                              .now()
                                                                          .toString(),
                                                                      "Seen":
                                                                          false,
                                                                    });
                                                                  });
                                                                  orderController
                                                                      .requestForComplete(
                                                                          orderStatus
                                                                              .id!);
                                                                  Get.back();
                                                                })
                                                            : PrimaryButton(
                                                                text:
                                                                    "See More",
                                                                onPressed:
                                                                    () {}),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                        }),
                          ],
                        ),
                      ),
                    );
                  });
            }
          })),
        ],
      ),
    ));
  }
}
