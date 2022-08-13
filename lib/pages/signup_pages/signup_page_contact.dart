import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/controllers/auth_controller.dart';
import 'package:whapp/controllers/registration_controller.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/helpers/teachers.dart';

class SignupPageContact extends StatefulWidget {
  const SignupPageContact({Key? key}) : super(key: key);

  @override
  State<SignupPageContact> createState() => _SignupPageContactState();
}

class _SignupPageContactState extends State<SignupPageContact> {
  final AuthController ac = Get.find();
  final RegistrationController rc = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(leading: const BackButton()),
      body: Container(
        padding: defaultPadding,
        child: FormBuilder(
          key: rc.contactFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Contact",
                    style: Get.textTheme.displayLarge,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      "Enter your contact information.",
                      style: Get.textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 50),
                  FormBuilderTextField(
                    name: "cellPhone",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: Get.textTheme.bodyMedium,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      label: Text("Cell Phone"),
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: "Enter your phone number"),
                      FormBuilderValidators.numeric(errorText: "Do not include dash (-)"),
                      FormBuilderValidators.equalLength(10, errorText: "Enter a valid phone number"),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  FormBuilderTextField(
                    name: "address",
                    textCapitalization: TextCapitalization.words,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: Get.textTheme.bodyMedium,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                      label: Text("Street Address"),
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: "Enter your street address"),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  FormBuilderDropdown(
                    name: "tShirtSize",
                    style: Get.textTheme.bodyMedium,
                    initialValue: "m",
                    decoration: const InputDecoration(label: Text("T-shirt size")),
                    items: const [
                      DropdownMenuItem(value: "xs", child: Text("X Small")),
                      DropdownMenuItem(value: "s", child: Text("Small")),
                      DropdownMenuItem(value: "m", child: Text("Medium")),
                      DropdownMenuItem(value: "l", child: Text("Large")),
                      DropdownMenuItem(value: "xl", child: Text("X Large")),
                      DropdownMenuItem(value: "2xl", child: Text("2X Large")),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (rc.contactFormKey.currentState!.validate()) {
                        Get.toNamed("/signup/3");
                      }
                    },
                    child: const Text("Continue"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: Get.textTheme.titleSmall,
                  ),
                  TextButton(
                    onPressed: () => Get.offAllNamed('/login'),
                    child: Text(
                      "Login",
                      style: Get.textTheme.titleSmall!.copyWith(
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
