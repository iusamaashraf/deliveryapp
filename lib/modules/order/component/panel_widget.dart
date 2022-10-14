import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodbari_deliver_app/Controller/order_controller.dart';
import 'package:foodbari_deliver_app/Models/all_request_model.dart';
import 'package:foodbari_deliver_app/Models/customer_model.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slidable_button/slidable_button.dart';
import '../../../utils/constants.dart';

class PannelCollapsComponent extends StatefulWidget {
  const PannelCollapsComponent({
    Key? key,
    required this.height,
    required this.customerModel,
  }) : super(key: key);
  final double height;
  final AllRequestModel customerModel;

  @override
  State<PannelCollapsComponent> createState() => _PannelCollapsComponentState();
}

final orderController = Get.find<OrderController>();

class _PannelCollapsComponentState extends State<PannelCollapsComponent> {
  bool isFinished = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 14),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
            height: 4,
            width: 60,
          ),
          const SizedBox(height: 12),
          _BottomWidget(customerModel: widget.customerModel)
        ],
      ),
    );
  }
}

class _BottomWidget extends StatelessWidget {
  _BottomWidget({
    Key? key,
    required this.customerModel,
  }) : super(key: key);
  final AllRequestModel customerModel;
  // var orderController=Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    double getTotal() => orderController.customerProducts != null
        ? orderController.customerProducts!.fold(0, (total, item) {
            double price = item.productPrice!;
            if (price != null) {
              return total + price;
            } else {
              return total;
            }
          })
        : 0.0;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Price:',
              style: TextStyle(
                  fontSize: 18, height: 1.16, fontWeight: FontWeight.w600),
            ),
            Obx(
              () => orderController.customerProducts == null
                  ? Text("0.0")
                  : Text(
                      '${getTotal()}',
                      style: const TextStyle(
                          fontSize: 18,
                          height: 1.16,
                          fontWeight: FontWeight.w600),
                    ),
            )
          ],
        ),
        const SizedBox(height: 16),
        IgnorePointer(
          ignoring: false,
          child: SlidableButton(
            height: 52,
            width: MediaQuery.of(context).size.width,
            buttonWidth: 50.0,
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
            buttonColor: redColor,
            dismissible: false,
            border: Border.all(color: borderColor),
            label: const Center(
                child: Icon(Icons.double_arrow_sharp, color: Colors.white)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Accept Delivery',
                    style: GoogleFonts.roboto(
                        color: redColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            disabledColor: Colors.grey,
            initialPosition: SlidableButtonPosition.left,
            onChanged: (position) {
              // print(position);
              // setState(() {
              if (position == SlidableButtonPosition.right) {
                orderController.acceptOrder(customerModel, context);
              } else {
                // result = 'Button is on the left';
              }
              // });
            },
          ),
        ),
      ],
    );
  }
}

class PanelComponent extends StatelessWidget {
  const PanelComponent({
    Key? key,
    this.controller,
  }) : super(key: key);

  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: const EdgeInsets.only(top: 16, bottom: 14, left: 20, right: 20),
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
            height: 4,
            width: 60,
          ),
        ),
        const SizedBox(height: 25),
        Text(
          'Bill Details',
          style: GoogleFonts.roboto(
              fontSize: 20, height: 1.15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Subtotal',
              style: TextStyle(fontSize: 16, height: 1.62),
            ),
            Text(
              '\$912.00',
              style: TextStyle(fontSize: 16, height: 1.62),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Discount',
              style: TextStyle(fontSize: 16, color: redColor),
            ),
            Text(
              '\$912.00',
              style: TextStyle(fontSize: 16, color: redColor),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(height: 1, color: borderColor),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Coupon Discount',
              style: TextStyle(fontSize: 16, color: redColor, height: 1.62),
            ),
            Text(
              '\$912.00',
              style: TextStyle(fontSize: 16, color: redColor, height: 1.62),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Delivery Fee',
              style: TextStyle(fontSize: 16, color: greenColor),
            ),
            Text(
              '\$912.00',
              style: TextStyle(fontSize: 16, color: greenColor),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(height: 1, color: borderColor),
        const SizedBox(height: 16),
        // const _BottomWidget(),
      ],
    );
  }
}
