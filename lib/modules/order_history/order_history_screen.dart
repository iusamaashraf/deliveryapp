import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodbari_deliver_app/Controller/auth_controller.dart';
import 'package:foodbari_deliver_app/Controller/push_notification_controller.dart';
import 'package:foodbari_deliver_app/Controller/request_controller.dart';
import 'package:get/get.dart';
import '../../Controller/order_controller.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../order/component/empty_order_component.dart';
import '../order/component/order_app_bar.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    // for (int i = 0; i < reqCon.offers!.length; i++) {
    //   isSent!.add(false);
    // }
    Get.find<AuthController>();
    Get.find<OrderController>();

    super.initState();
  }

  var reqCon = Get.put(RequestController());

  List<bool> isSent = [];
  // bool isSent = false;

  var authController = Get.find<AuthController>();
  var orderController = Get.find<OrderController>();
  @override
  Widget build(BuildContext context) {
    const double appBarHeight = 174;
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            collapsedHeight: appBarHeight,
            expandedHeight: appBarHeight,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: redColor),
            flexibleSpace: OrderAppBar(height: appBarHeight),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          //OrderedHistoryListComponent(orderedList: orderProductList),
          // const SliverToBoxAdapter(child: EmptyOrderComponent()),
          SliverToBoxAdapter(
            child: GetX<RequestController>(
                init: Get.put<RequestController>(RequestController()),
                builder: (RequestController requestController) {
                  if (requestController.offers == null ||
                      requestController.offers!.isEmpty) {
                    // for (int i = 0;
                    //     i <= requestController.offers!.length;
                    //     i++) {
                    //   isSent!.add(false);
                    // }

                    return const EmptyOrderComponent();
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: requestController.offers!.length,
                        itemBuilder: (context, index) {
                          var request = requestController.offers![index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12, blurRadius: 12),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          NetworkImage(request.customer_image!),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(request.customer_name!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                        Text(
                                            Utils.formatDate(
                                                request.time!.toDate()),
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .copyWith(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(request.title!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                Text(request.description!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.currency_exchange,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 10),
                                    Text('\$ ${request.price.toString()}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: redColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // print(Get.put(AuthController())
                                      //     .deliveryBoyModel
                                      //     .value!
                                      //     .email);
                                      reqCon.sentOffer(
                                          context: context,
                                          noOfRequest: request.noOfRequest,
                                          offerId: request.id,
                                          customerID: request.customer_id);
                                      print(
                                          "token is : ${Get.find<AuthController>().token}");
                                    },
                                    // onPressed: isSent![index] == true
                                    //     ? () {
                                    //         setState(() {
                                    //           isSent![index] = true;
                                    //         });
                                    //       }
                                    // : null,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      // minimumSize: minimumSize,
                                      // maximumSize: maximumSize,
                                      primary: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: const Text(
                                      "Send Offer",
                                      style: TextStyle(
                                          fontSize: 15,
                                          height: 1.5,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
