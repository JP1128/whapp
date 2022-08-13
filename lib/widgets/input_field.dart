import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whapp/controllers/auth_controller.dart';

class EmailInputField extends StatefulWidget {
  const EmailInputField({
    Key? key,
    required this.controller,
    required this.textInputAction,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputAction textInputAction;

  @override
  State<EmailInputField> createState() => _EmailInputFieldState();
}

class _EmailInputFieldState extends State<EmailInputField> {
  AuthController ac = Get.find();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Get.textTheme.bodyMedium,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: const InputDecoration(
        label: Text("Email address"),
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (email) {
        if (email == null || EmailValidator.validate(email)) {
          return null;
        }

        return "Invalid Email";
      },
    );
  }
}

class PasswordInputField extends StatefulWidget {
  const PasswordInputField({
    Key? key,
    required this.controller,
    required this.textInputAction,
    required this.autoFillHints,
    required this.confirmPassword,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputAction textInputAction;
  final String autoFillHints;
  final bool confirmPassword;

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  AuthController ac = Get.find();

  final Rx<bool> _hidePassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFormField(
          style: Get.textTheme.bodyMedium,
          textInputAction: widget.textInputAction,
          controller: widget.controller,
          autofillHints: [widget.autoFillHints],
          keyboardType: TextInputType.visiblePassword,
          obscureText: _hidePassword.value,
          autocorrect: false,
          decoration: InputDecoration(
            label: Text(widget.confirmPassword ? "Confirm password" : "Password"),
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: InkResponse(
              radius: 20,
              child: Icon(_hidePassword.value ? Icons.visibility : Icons.visibility_off),
              onTap: () => _hidePassword.value = !_hidePassword.value,
            ),
          ),
        ));
  }
}
