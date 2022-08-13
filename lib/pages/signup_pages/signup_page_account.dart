import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/controllers/auth_controller.dart';
import 'package:whapp/controllers/registration_controller.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/widgets/input_field.dart';

class SignupPageAccount extends StatefulWidget {
  const SignupPageAccount({Key? key}) : super(key: key);

  @override
  State<SignupPageAccount> createState() => _SignupPageAccountState();
}

class _SignupPageAccountState extends State<SignupPageAccount> {
  final AuthController ac = Get.find();
  final RegistrationController rc = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(leading: const BackButton()),
      body: Container(
        padding: defaultPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Create Account",
                  style: Get.textTheme.displayLarge,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    "Enter your account credentials.",
                    style: Get.textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 50),
                EmailInputField(
                  controller: ac.emailController,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 30),
                PasswordInputField(
                  controller: ac.passwordController,
                  textInputAction: TextInputAction.next,
                  autoFillHints: AutofillHints.newPassword,
                  confirmPassword: false,
                ),
                const SizedBox(height: 30),
                PasswordInputField(
                  controller: ac.confirmPasswordController,
                  textInputAction: TextInputAction.next,
                  autoFillHints: AutofillHints.newPassword,
                  confirmPassword: true,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => {},
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}
