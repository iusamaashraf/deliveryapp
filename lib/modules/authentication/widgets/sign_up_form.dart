import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/Controller/auth_controller.dart';
import 'package:get/get.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/primary_button.dart';
import 'guest_button.dart';
import 'social_buttons.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _passwordVisible = false;
  bool _checkBoxSelect = false;
  var authController = Get.find<AuthController>();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _key,
        child: Column(
          children: [
            const SizedBox(height: 12),
            TextFormField(
              controller: authController.signUpNameController,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter name';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Enter name',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: authController.signUpEmailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter email';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Enter email',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: authController.signUpPasswordController,
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
            const SizedBox(height: 16),
            TextFormField(
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
                text: 'Sign Up',
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    try {
                      authController.signUp(
                          authController.signUpEmailController.text.trim(),
                          authController.signUpPasswordController.text,
                          authController.signUpNameController.text,
                          context);
                    } catch (e) {
                      Get.snackbar("Error", e.toString());
                    }
                  }
                }),
            const SizedBox(height: 16),
            const Text(
              'Sign Up With Social',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const SocialButtons(),
            const SizedBox(height: 28),
            const GuestButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRememberMe() {
    return CheckboxListTile(
      value: _checkBoxSelect,
      dense: true,
      contentPadding: EdgeInsets.zero,
      checkColor: Colors.white,
      activeColor: redColor,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        'I Consent To The Privacy Policy',
        style: TextStyle(color: blackColor.withOpacity(.5)),
      ),
      onChanged: (v) {
        if (v == null) return;
        setState(() {
          _checkBoxSelect = v;
        });
      },
    );
  }
}
