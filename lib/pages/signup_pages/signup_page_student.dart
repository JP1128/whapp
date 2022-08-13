import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/controllers/auth_controller.dart';
import 'package:whapp/controllers/registration_controller.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/helpers/teachers.dart';

class SignupPageStudent extends StatefulWidget {
  const SignupPageStudent({Key? key}) : super(key: key);

  @override
  State<SignupPageStudent> createState() => _SignupPageStudentState();
}

class _SignupPageStudentState extends State<SignupPageStudent> {
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
          key: rc.studentFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Let's Get Started",
                    style: Get.textTheme.displayLarge,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text("Enter your student information.", style: Get.textTheme.bodyMedium),
                  ),
                  const SizedBox(height: 50),
                  FormBuilderTextField(
                    name: "fullName",
                    textCapitalization: TextCapitalization.words,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: Get.textTheme.bodyMedium,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      label: Text("Full name"),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(errorText: "Enter your full name"),
                        (val) {
                          if (val == null) return null;
                          return !nameRegExp.hasMatch(val) //
                              ? "Enter a valid full name"
                              : null;
                        }
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormBuilderTextField(
                    name: "studentId",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: Get.textTheme.bodyMedium,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text("Student ID"),
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(errorText: "Enter your student ID"),
                        FormBuilderValidators.numeric(errorText: "Student ID must consist only of numbers"),
                        FormBuilderValidators.minLength(7, errorText: "Student ID must have at least 7 digits"),
                        FormBuilderValidators.maxLength(8, errorText: "Student ID must have at most 8 digits"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FormBuilderTextField(
                          name: "homeroom",
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: Get.textTheme.bodyMedium,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.name],
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            label: Text("Homeroom Teacher"),
                            hintText: "Mr. Dewar",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(errorText: "Enter your homeroom teacher"),
                            (val) {
                              if (val == null) return null;
                              return !homeroomNameRegExp.hasMatch(val) //
                                  ? "Enter a valid name"
                                  : null;
                            }
                          ]),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 90,
                        child: FormBuilderDropdown(
                          name: "gradeLevel",
                          style: Get.textTheme.bodyMedium,
                          initialValue: 9,
                          decoration: const InputDecoration(label: Text("Grade")),
                          items: const [
                            DropdownMenuItem(value: 9, child: Text("9")),
                            DropdownMenuItem(value: 10, child: Text("10")),
                            DropdownMenuItem(value: 11, child: Text("11")),
                            DropdownMenuItem(value: 12, child: Text("12")),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (rc.studentFormKey.currentState!.validate()) {
                        Get.toNamed("/signup/2");
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
