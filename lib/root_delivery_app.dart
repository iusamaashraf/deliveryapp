import 'package:flutter/cupertino.dart';
import 'package:foodbari_deliver_app/Controller/auth_controller.dart';
import 'package:foodbari_deliver_app/modules/main_page/main_page.dart';
import 'package:get/get.dart';

import 'modules/authentication/authentication_screen.dart';

class RootDelivery extends StatelessWidget {
  RootDelivery({Key? key}) : super(key: key);
  final userController = Get.put<AuthController>(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      initState: (_) {
        Get.put<AuthController>(AuthController());
      },
      builder: (_) {
        if (Get.find<AuthController>().user != null) {
          return MainPage();
        } else {
          return AuthenticationScreen();
        }
      },
    );
  }
}
