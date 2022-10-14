import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/Controller/auth_controller.dart';
import 'package:get/get.dart';
import '../../../../router_name.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/primary_button.dart';
import 'guest_button.dart';
import 'social_buttons.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({Key? key}) : super(key: key);

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  var authController = Get.find<AuthController>();
  bool _checkBoxSelect = false;
  bool _passwordVisible = false;
  GlobalKey<FormState> _keySecond = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _keySecond,
        child: Column(
          children: [
            const SizedBox(height: 12),
            TextFormField(
              controller: authController.signInEmailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter username or email';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Username or email',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: authController.signInPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Password';
                }
                return null;
              },
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: grayColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildRememberMe(),
            const SizedBox(height: 25),
            PrimaryButton(
              text: 'Sign In',
              onPressed: () {
                if (_keySecond.currentState!.validate()) {
                  try {
                    authController.login(
                        authController.signInEmailController.text.trim(),
                        authController.signInPasswordController.text,
                        context);
                  } catch (e) {
                    Get.snackbar("Error", e.toString());
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Sign In With Social',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const SocialButtons(),
            const SizedBox(height: 25),
            const GuestButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRememberMe() {
    return Row(
      children: [
        Flexible(
          child: CheckboxListTile(
            value: _checkBoxSelect,
            dense: true,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            contentPadding: EdgeInsets.zero,
            checkColor: Colors.white,
            activeColor: redColor,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              'Remember me',
              style: TextStyle(color: blackColor.withOpacity(.5)),
            ),
            onChanged: (bool? v) {
              if (v == null) return;
              setState(() {
                _checkBoxSelect = v;
              });
            },
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteNames.forgotScreen);
          },
          child: const Text(
            'Forgot password?',
            style: TextStyle(color: redColor),
          ),
        ),
      ],
    );
  }
}
