import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:whapp/controllers/auth_controller.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({
    Key? key,
    required this.pc,
  }) : super(key: key);

  final PageController pc;

  @override
  State<AccountForm> createState() => AccountFormState();
}

class AccountFormState extends State<AccountForm> {
  final AuthController _ac = Get.find();

  final _fk = GlobalKey<FormBuilderState>();

  final _hidePassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _fk,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Almost Done!", style: Get.textTheme.displayLarge),
            const SizedBox(height: 10),
            Text("Enter your account credentials", style: Get.textTheme.bodyMedium),
            const SizedBox(height: 50),
            FormBuilderTextField(
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
            const SizedBox(height: 20),
            Obx(() => FormBuilderTextField(
                  name: "password",
                  style: Get.textTheme.bodyMedium,
                  controller: _ac.passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  autofillHints: [AutofillHints.newPassword],
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _hidePassword.value,
                  decoration: InputDecoration(
                    label: const Text("Password"),
                    suffixIcon: InkResponse(
                      radius: 20,
                      child: Icon(_hidePassword.value ? Icons.visibility : Icons.visibility_off),
                      onTap: () => _hidePassword.value = !_hidePassword.value,
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Enter your password"),
                    FormBuilderValidators.minLength(5, errorText: "Your password must be at least 5 characters"),
                  ]),
                )),
            const SizedBox(height: 20),
            FormBuilderTextField(
              name: "confirmPassword",
              style: Get.textTheme.bodyMedium,
              controller: _ac.confirmPasswordController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              autofillHints: [AutofillHints.newPassword],
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(label: const Text("Confirm Password")),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Enter your password again"),
                (val) {
                  if (val == null) return null;

                  if (val != _ac.passwordController.text) {
                    return "The passwords must be the same";
                  }
                },
              ]),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                OutlinedButton(
                  child: const Text("Back"),
                  onPressed: () {
                    if (widget.pc.hasClients) {
                      widget.pc.previousPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_fk.currentState!.saveAndValidate()) {
                      _ac.createAccount();
                    }
                  },
                  child: const Text("Create Account"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
