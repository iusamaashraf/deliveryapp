import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/Controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../../../router_name.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/k_images.dart';
import '../../../../widgets/custom_image.dart';

class OrderAppBar extends StatefulWidget {
  final double height;

  OrderAppBar({Key? key, this.height = 140}) : super(key: key);

  @override
  State<OrderAppBar> createState() => _OrderAppBarState();
}

class _OrderAppBarState extends State<OrderAppBar> {
  var authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            SizedBox(height: widget.height, width: media.size.width),
            const Positioned(
              left: -21,
              top: -74,
              child: CircleAvatar(
                radius: 105,
                backgroundColor: redColor,
              ),
            ),
            Positioned(
              left: -31,
              top: -113,
              child: CircleAvatar(
                radius: 105,
                backgroundColor: Colors.white.withOpacity(0.06),
              ),
            ),
            Positioned(
              left: -33,
              top: -156,
              child: CircleAvatar(
                radius: 105,
                backgroundColor: Colors.white.withOpacity(0.06),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // SizedBox(height: 60 - statusbarPadding),
                    _buildappBarButton(context),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xff333333)
                                        .withOpacity(.18),
                                    blurRadius: 70),
                              ],
                            ),
                            child: TextFormField(
                              decoration: inputDecorationTheme.copyWith(
                                prefixIcon: const Icon(Icons.search_rounded,
                                    color: grayColor, size: 26),
                                hintText: 'Search your products',
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                              color: redColor,
                              borderRadius: BorderRadius.circular(4)),
                          margin: const EdgeInsets.only(right: 8),
                          height: 52,
                          width: 44,
                          child: const Center(
                            child: CustomImage(
                              path: Kimages.menuIcon,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isOnline = false;

  Widget _buildappBarButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLocation(),
                // const SizedBox(
                //   width: 50,
                // ),
                FlutterSwitch(
                  width: 100.0,
                  height: 37.0,
                  valueFontSize: 18.0,
                  toggleSize: 27.0,
                  value: isOnline,
                  borderRadius: 30.0,
                  padding: 4.0,
                  activeColor: redColor,
                  inactiveColor: redColor,
                  activeTextColor: Colors.white,
                  inactiveTextColor: Colors.white,
                  activeText: 'Online',
                  inactiveText: 'Offline',
                  showOnOff: isOnline,
                  onToggle: (val) {
                    setState(() {
                      isOnline = !isOnline;
                    });
                    print(isOnline);
                  },
                ),
                // const SizedBox(width: 10),
                Obx(
                  () => InkWell(
                    onTap: () async {
                      Get.find<AuthController>().notifyCounter.value = 0;
                      Navigator.pushNamed(
                          context, RouteNames.notificationScreen);
                      await FirebaseFirestore.instance
                          .collection("delivery_boy")
                          .doc(Get.find<AuthController>().user!.uid)
                          .collection("Notifications")
                          .where("Seen", isEqualTo: false)
                          .get()
                          .then((value) {
                        for (int i = 0; i < value.docs.length; i++) {
                          FirebaseFirestore.instance
                              .collection("delivery_boy")
                              .doc(Get.find<AuthController>().user!.uid)
                              .collection("Notifications")
                              .doc(value.docs[i].id)
                              .update({"Seen": true});
                        }
                      });
                    },
                    child: Get.find<AuthController>().notifyCounter.value == 0
                        ? const Icon(Icons.notifications,
                            size: 28, color: paragraphColor)
                        : Badge(
                            position: const BadgePosition(top: -5, end: -3),
                            badgeContent:  Text(
                              Get.find<AuthController>().notifyCounter.value.toString(),
                              style:
                                 const TextStyle(fontSize: 8, color: Colors.white),
                            ),
                            child: const Icon(Icons.notifications,
                                size: 28, color: paragraphColor),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return GestureDetector(
      onTap: () async {
        await authController.getCurrentLocation().then((value) async {
          await authController.updateLocation();
        });
      },
      child: Row(
        children: [
          const Icon(
            Icons.my_location_outlined,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Obx(
            () => authController.deliveryBoyModel.value == null
                // ||
                //         authController.dBoyAddress.value == "" ||
                //         authController.dBoyAddress.value.isEmpty
                ? Text(
                    'Get Location',
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  )
                : Container(
                    width: 130,
                    child: Text(
                      authController.deliveryBoyModel.value!.address!,
                      style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
          ),
          // const Icon(
          //   Icons.keyboard_arrow_down_outlined,
          //   color: Colors.white,
          // )
        ],
      ),
    );
  }
}
