import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:foodbari_deliver_app/Controller/auth_controller.dart';
import 'package:foodbari_deliver_app/Controller/request_controller.dart';
import 'package:foodbari_deliver_app/Models/delivery_model.dart';
import 'package:foodbari_deliver_app/modules/main_page/main_page.dart';
import 'package:foodbari_deliver_app/modules/order/component/panel_widget.dart';
import 'package:foodbari_deliver_app/utils/constants.dart';
import 'package:foodbari_deliver_app/widgets/app_bar_leading.dart';
import 'package:foodbari_deliver_app/widgets/primary_button.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  MapScreen(
      {Key? key,
      required this.pickLat,
      required this.pickLng,
      required this.dropLat,
      required this.dropLng,
      required this.orderId
      // required this.modelData,
      // required this.rating,
      // required this.destinationLng,
      })
      : super(key: key);
  double pickLat;
  double pickLng;
  double dropLat;
  double dropLng;
  String orderId;
  // DeliveryBoyModel modelData;
  // double rating;
  // final double destinationLng;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

// LocationData? currentLocation;
GoogleMapController? googleMapController;
final authController = Get.put(AuthController());
final requestController = Get.put(RequestController());

class _MapScreenState extends State<MapScreen> {
  // static LatLng sourceLocation = LatLng(authController.deliveryBoyLat.value,
  //     authController.deliveryBoyLong.value);

  List<LatLng> polylineCoordinates = [];

  LatLng? destination;
  LatLng? origin;
  Future<void> getPolyPoints() async {
    destination = LatLng(widget.dropLat, widget.dropLng);
    origin = LatLng(widget.pickLat, widget.pickLng);

    PolylinePoints polylinePoints = PolylinePoints();
    // PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        // APIClass().API,
        'AIzaSyAzr66eCsT-AfdfVw5zoFG0guIHFOeIDr0',
        PointLatLng(widget.pickLat, widget.pickLng),
        PointLatLng(widget.dropLat, widget.dropLng));
    print("result points is: ${result.points}");

    // print(
    //     'Lattitude:${PointLatLng(authController.currentLocation!.latitude!, authController.currentLocation!.longitude!)}');
    if (result.points.isNotEmpty) {
      print('it is working');
      // ignore: avoid_function_literals_in_foreach_calls
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        print('print :$polylineCoordinates');
        // FirebaseFirestore.instance
        //     .collection("delivery_boy")
        //     .doc(FirebaseAuth.instance.currentUser!.uid)
        //     .update({'location': GeoPoint(point.latitude, point.longitude)});
        setState(() {});
      });

      setState(() {});
    }
  }

  // bool isLoading = false;
  @override
  void initState() {
    orderController.getCurrentOrder(widget.orderId);
    // Timer(Duration(seconds: 3), () {
    //   setState(() {
    //     isLoading = true;
    //   });
    // });

    getPolyPoints();

    super.initState();
  }

  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    // getPolyPoints();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          requestController.distanceModel.value != null
              ? GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(widget.pickLat, widget.pickLng),
                      zoom: 18.5),
                  polylines: {
                    Polyline(
                        polylineId: const PolylineId("new"),
                        points: polylineCoordinates,
                        color: Colors.red,
                        width: 10),
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId("currentLocation"),
                      position: LatLng(
                        widget.pickLat,
                        widget.pickLng,
                      ),
                    ),
                    // Marker(
                    //     markerId: const MarkerId("source"),
                    //     position: LatLng(
                    //         authController.currentLocation!.latitude!,
                    //         authController.currentLocation!.longitude!)),
                    Marker(
                      markerId: const MarkerId("destination"),
                      position: destination!,
                    ),
                  },
                  onMapCreated: (mapController) {
                    googleMapController = mapController;
                    //  authController.controllerCompleter.complete(mapController);
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          AnimatedPositioned(
            curve: Curves.fastOutSlowIn,
            height: size.height * 0.18,
            width: size.width * 0.9,
            duration: const Duration(
              seconds: 1,
            ),
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSelected = !isSelected;
                });
              },
              child: Container(
                // height: size.height * 0.3,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tracking Location',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Delivery Time',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              Text(
                                requestController.distanceModel.value!.rows![0]
                                    .elements![0].duration!.text!,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        child: SizedBox(
                            width: size.width * 0.5,
                            child: PrimaryButton(
                                text: 'Go to Home',
                                onPressed: () {
                                  Get.offAll(() => MainPage());
                                })),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.04,
            child: Container(
              height: size.height * 0.1,
              width: size.width * 0.95,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: redColor),
            ),
          ),
          // const Positioned(
          //   left: -21,
          //   top: -10,
          //   child: CircleAvatar(
          //     radius: 50,
          //     backgroundColor: redColor,
          //   ),
          // ),
          Positioned(
            left: 40,
            top: -10,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(0.06),
            ),
          ),
          Positioned(
            left: 20,
            top: 40,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withOpacity(0.06),
            ),
          ),
          Positioned(
            left: size.width * 0.05,
            top: size.height * 0.07,
            child: Row(
              children: [
                const AppbarLeading(),
                const SizedBox(
                  width: 10,
                ),
                Text("Order Status",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Positioned(
            top: size.height * 0.15,
            child: Container(
              padding: EdgeInsets.all(12),
              // height: size.height * 0.05,
              // width: size.width * 0.3,
              decoration: BoxDecoration(
                  color: redColor, borderRadius: BorderRadius.circular(100)),
              child: Center(
                child: Text(
                  "${requestController.distanceModel.value!.rows![0].elements![0].distance!.text!} away",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
