import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/Controller/order_controller.dart';
import 'package:foodbari_deliver_app/Models/all_request_model.dart';
import 'package:foodbari_deliver_app/Models/customer_model.dart';
import 'package:foodbari_deliver_app/Models/product_model.dart';
import 'package:foodbari_deliver_app/modules/order/model/product_order_model.dart';
import 'package:foodbari_deliver_app/utils/utils.dart';
import 'package:foodbari_deliver_app/widgets/custom_image.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../router_name.dart';
import '../../utils/constants.dart';
import '../../widgets/rounded_app_bar.dart';
import 'component/cart_item_header.dart';
import 'component/cart_product_list.dart';
import 'component/panel_widget.dart';
import 'model/product_model.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key, required this.customerModel})
      : super(key: key);
  final AllRequestModel customerModel;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final panelController = PanelController();
  final double height = 145;

  final headerStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(
        titleText: 'Order Products',
        // actionButtons: [
        //   InkWell(
        //     onTap: () {
        //       Navigator.pushNamed(context, RouteNames.orderTrackingScreen);
        //     },
        //     child: const CircleAvatar(
        //       radius: 14,
        //       backgroundColor: Colors.white,
        //       child: Icon(
        //         Icons.delivery_dining_outlined,
        //         size: 20,
        //         color: blackColor,
        //       ),
        //     ),
        //   ),
        //   const SizedBox(width: 20),
        // ],
      ),
      body: SlidingUpPanel(
        controller: panelController,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        // panel: const PanelComponent(),
        panelBuilder: (sc) => PanelComponent(controller: sc),
        minHeight: height,
        maxHeight: 50,
        backdropEnabled: true,
        backdropTapClosesPanel: true,
        parallaxEnabled: false,
        backdropOpacity: 0.0,
        collapsed: PannelCollapsComponent(
            height: height, customerModel: widget.customerModel),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    final width = MediaQuery.of(context).size.width - 40;
    double height = 100;
    final bottstats = MediaQuery.of(context).padding.bottom;
    return GetX<OrderController>(
        init: Get.put<OrderController>(OrderController()),
        builder: (OrderController orderController) {
          if (orderController.customerProducts != null &&
              orderController.customerProducts!.isNotEmpty) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: orderController.customerProducts!.length,
                itemBuilder: (context, index) {
                  var oder = orderController.customerProducts![index];
                  return Container(
                    height: 100,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: borderColor),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border:
                                Border(right: BorderSide(color: borderColor)),
                          ),
                          height: height - 2,
                          width: width / 2.7,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(4)),
                            child: CustomImage(
                              path: oder.productImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                oder.productName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                Utils.formatPrice(oder.productPrice!),
                                style: const TextStyle(
                                    color: redColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              // const IncreaseDecreaseCard(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
