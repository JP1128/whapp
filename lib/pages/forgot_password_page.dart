import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/controllers/auth_controller.dart';
import 'package:whapp/widgets/input_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final AuthController ac = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: Container(
        padding: defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Reset password",
              style: Get.textTheme.displayLarge,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                  "Enter the email associated with your account "
                  "and we'll send an email with "
                  "instructions to reset your password. Check your "
                  "spam folder if you have not received your email.",
                  style: Get.textTheme.bodyMedium),
            ),
            const SizedBox(height: 50),
            EmailInputField(
              controller: ac.emailController,
              textInputAction: TextInputAction.go,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => ac.sendPasswordResetEmail(),
              child: const Text("Send Reset Link"),
            ),
          ],
        ),
      ),
    );
  }
}
