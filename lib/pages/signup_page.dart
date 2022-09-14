import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/member.dart';
import 'package:whapp/services/firebase_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _fk = GlobalKey<FormBuilderState>();

  final _pageController = PageController();

  var _hidePassword = true;

  String? _fullName;
  String? _studentId;
  String? _homeroom;
  String? _gradeLevel;

  String? _phoneNumber;
  String? _streetAddress;
  String? _tShirtSize;

  String? _email;
  String? _password;

  Uint8List? avatar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: Column(
        children: [
          SmoothPageIndicator(
              controller: _pageController, // PageController
              count: 3,
              effect: const WormEffect(
                dotHeight: 10.0,
                dotWidth: 10.0,
                type: WormType.thin,
                activeDotColor: primaryColor,
              ), // your preferred effect
              onDotClicked: (index) {}),
          const SizedBox(height: 30.0),
          Expanded(
            child: FormBuilder(
              key: _fk,
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: hPad,
                      child: Column(
                        children: [
                          Text(
                            "Let's get started",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Enter your student information",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 50),
                          FormBuilderTextField(
                            name: "fullName",
                            style: Theme.of(context).textTheme.bodyMedium,
                            textCapitalization: TextCapitalization.words,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.name],
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(label: Text("Full name")),
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(errorText: "Enter your full name"),
                                valueMatch(nameRegExp, "Enter a valid full name"),
                              ],
                            ),
                            onSaved: (val) => _fullName = val,
                          ),
                          const SizedBox(height: 20),
                          FormBuilderTextField(
                            name: "studentId",
                            style: Theme.of(context).textTheme.bodyMedium,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(label: Text("Student ID")),
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(errorText: "Enter your student ID"),
                                FormBuilderValidators.numeric(errorText: "Student ID must be numeric"),
                                FormBuilderValidators.minLength(7, errorText: "Student ID must have at least 7 digits"),
                                FormBuilderValidators.maxLength(8, errorText: "Student ID must have at most 8 digits"),
                              ],
                            ),
                            onSaved: (val) => _studentId = val,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: FormBuilderTextField(
                                  name: "homeroom",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textCapitalization: TextCapitalization.words,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.name],
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(label: Text("Homeroom Teacher"), hintText: "Mr. Dewar"),
                                  validator: FormBuilderValidators.compose(
                                    [
                                      FormBuilderValidators.required(errorText: "Enter your homeroom teacher"),
                                      valueMatch(homeroomNameRegExp, "Enter a valid name"),
                                    ],
                                  ),
                                  onSaved: (val) => _homeroom = val,
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 125,
                                child: FormBuilderDropdown<String>(
                                  name: "gradeLevel",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(label: Text("Grade")),
                                  items: const [
                                    DropdownMenuItem(value: "supervisor", child: Text("Supervisor")),
                                    DropdownMenuItem(value: "freshman", child: Text("9")),
                                    DropdownMenuItem(value: "sophomore", child: Text("10")),
                                    DropdownMenuItem(value: "junior", child: Text("11")),
                                    DropdownMenuItem(value: "senior", child: Text("12")),
                                  ],
                                  validator: FormBuilderValidators.compose(
                                    [
                                      FormBuilderValidators.required(errorText: "Required"),
                                    ],
                                  ),
                                  onSaved: (val) => _gradeLevel = val,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              if (_fk.currentState!.saveAndValidate()) {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 600),
                                  curve: Curves.easeIn,
                                );
                              }
                            },
                            child: const Text("Continue"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: hPad,
                      child: Column(
                        children: [
                          Text(
                            "Almost done!",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Enter your contact information",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 50),
                          FormBuilderTextField(
                            name: "phoneNumber",
                            style: Theme.of(context).textTheme.bodyMedium,
                            textCapitalization: TextCapitalization.words,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.telephoneNumber],
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              label: Text("Phone Number"),
                              hintText: "(123) 456-7890",
                            ),
                            inputFormatters: [
                              MaskTextInputFormatter(
                                mask: "(###) ###-####",
                                filter: {"#": RegExp(r'[0-9]')},
                                type: MaskAutoCompletionType.lazy,
                              )
                            ],
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(errorText: "Enter your phone number"),
                              ],
                            ),
                            onSaved: (val) => _phoneNumber = val,
                          ),
                          const SizedBox(height: 20),
                          FormBuilderTextField(
                            name: "streetAddress",
                            style: Theme.of(context).textTheme.bodyMedium,
                            textCapitalization: TextCapitalization.words,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.streetAddress,
                            decoration: const InputDecoration(
                              label: Text("Street Address"),
                              hintText: "1234 Rainbow Street",
                            ),
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(errorText: "Enter your street address"),
                                (value) {
                                  if (value == null) return null;

                                  value = value.toLowerCase();
                                  if (value.contains(',')) {
                                    return "Do not include city and state";
                                  }
                                }
                              ],
                            ),
                            onSaved: (val) => _streetAddress = val,
                          ),
                          const SizedBox(height: 20),
                          FormBuilderDropdown<String>(
                            name: "tShirtSize",
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: const InputDecoration(label: Text("T-shirt size")),
                            items: const [
                              DropdownMenuItem(value: "xs", child: Text("X Small")),
                              DropdownMenuItem(value: "s", child: Text("Small")),
                              DropdownMenuItem(value: "m", child: Text("Medium")),
                              DropdownMenuItem(value: "l", child: Text("Large")),
                              DropdownMenuItem(value: "xl", child: Text("X Large")),
                              DropdownMenuItem(value: "2xl", child: Text("2X Large")),
                            ],
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(errorText: "Required"),
                              ],
                            ),
                            onSaved: (val) => _tShirtSize = val,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              // Flexible(
                              //   child: OutlinedButton(
                              //     child: const Text("Back"),
                              //     onPressed: () {
                              //       _pageController.previousPage(
                              //         duration: const Duration(milliseconds: 600),
                              //         curve: Curves.easeOut,
                              //       );
                              //     },
                              //   ),
                              // ),
                              // const SizedBox(width: 20),
                              Flexible(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_fk.currentState!.saveAndValidate()) {
                                      _pageController.nextPage(
                                        duration: const Duration(milliseconds: 600),
                                        curve: Curves.easeIn,
                                      );
                                    }
                                  },
                                  child: const Text("Continue"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: hPad,
                      child: Column(
                        children: [
                          Text(
                            "Lastly",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Enter your account credentials",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 50),
                          FormBuilderTextField(
                            name: "email",
                            style: Theme.of(context).textTheme.bodyMedium,
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
                            onSaved: (val) => _email = val,
                          ),
                          const SizedBox(height: 20),
                          FormBuilderTextField(
                            name: "password",
                            style: Theme.of(context).textTheme.bodyMedium,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.newPassword],
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _hidePassword,
                            decoration: InputDecoration(
                              label: const Text("Password"),
                              suffixIcon: InkResponse(
                                radius: 20,
                                child: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                                onTap: () => setState(() => _hidePassword = !_hidePassword),
                              ),
                            ),
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(errorText: "Enter your password"),
                                FormBuilderValidators.minLength(5, errorText: "Your password must be at least 5 characters"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              // Flexible(
                              //   child: OutlinedButton(
                              //     child: const Text("Back"),
                              //     onPressed: () {
                              //       _pageController.previousPage(
                              //         duration: const Duration(milliseconds: 600),
                              //         curve: Curves.easeOut,
                              //       );
                              //     },
                              //   ),
                              // ),
                              // const SizedBox(width: 20),
                              Flexible(
                                child: ElevatedButton(
                                  onPressed: () {
                                    var fs = FirebaseService.instance;
                                    if (_fk.currentState!.saveAndValidate()) {
                                      fs.createAccount(context, _email!.trim(), _password!.trim()) //
                                          .then(
                                        (userCredential) {
                                          if (userCredential != null) {
                                            var user = userCredential.user;
                                            fs.updateMember(Member(
                                              uid: user!.uid,
                                              emailAddress: _email!,
                                              photoURL: null,
                                              role: 3,
                                              points: 0,
                                              minutes: 0,
                                              collection: 0.0,
                                              fullName: _fullName!,
                                              studentId: _studentId!,
                                              homeroom: _homeroom!,
                                              gradeLevel: _gradeLevel!,
                                              phoneNumber: _phoneNumber!,
                                              streetAddress: _streetAddress!,
                                              tShirtSize: _tShirtSize!,
                                              tShirtReceived: false,
                                              duesPaid: false,
                                            ));
                                          }
                                          fs.login(context, _email!, _password!);
                                        },
                                      );
                                    }
                                  },
                                  child: const Text("Create account"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
