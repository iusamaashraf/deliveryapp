import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/Controller/auth_controller.dart';
import 'package:get/get.dart';
import '../../../widgets/primary_button.dart';

class ProfielEditForm extends StatelessWidget {
  ProfielEditForm({Key? key}) : super(key: key);
  AuthController controller = Get.find<AuthController>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              controller.deliveryBoyModel.value!.name!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  hintText: controller.deliveryBoyModel.value!.name),
            ),
            const SizedBox(height: 16),
            TextFormField(
              enabled: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: controller.deliveryBoyModel.value!.email,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: controller.deliveryBoyModel.value!.phone == ""
                    ? "Phone no"
                    : controller.deliveryBoyModel.value!.phone,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              enabled: false,
              controller: locationController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                hintText: controller.deliveryBoyModel.value!.address,
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
                text: 'Update Account',
                onPressed: () {
                  controller.updateProfile(
                      name: nameController.text,
                      phone: phoneController.text,
                      context: context);
                })
          ],
        ),
      ),
    );
  }
}
