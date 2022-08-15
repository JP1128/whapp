import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/controllers/auth_controller.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final AuthController _ac = Get.find();

  final _fk = GlobalKey<FormBuilderState>();

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
            FormBuilder(
              child: FormBuilderTextField(
                name: "email",
                controller: _ac.emailController,
                style: Get.textTheme.bodyMedium,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(label: Text("Email address")),
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(errorText: "Enter your email address"),
                    FormBuilderValidators.email(errorText: "Enter a valid email"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_fk.currentState!.validate()) {
                  _ac.sendPasswordResetEmail();
                }
              },
              child: const Text("Send Reset Link"),
            ),
          ],
        ),
      ),
    );
  }
}
