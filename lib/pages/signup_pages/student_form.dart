import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:whapp/controllers/auth_controller.dart';
import 'package:whapp/helpers/helper.dart';

class StudentForm extends StatefulWidget {
  const StudentForm({
    Key? key,
    required this.pc,
  }) : super(key: key);

  final PageController pc;

  @override
  State<StudentForm> createState() => StudentFormState();
}

class StudentFormState extends State<StudentForm> {
  final AuthController _ac = Get.find();

  final _fk = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _fk,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Let's get started", style: Get.textTheme.displayLarge),
              const SizedBox(height: 10),
              Text("Enter your student information", style: Get.textTheme.bodyMedium),
              const SizedBox(height: 50),
              FormBuilderTextField(
                name: "fullName",
                style: Get.textTheme.bodyMedium,
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
                onSaved: (val) => _ac.fullName = val,
              ),
              const SizedBox(height: 20),
              FormBuilderTextField(
                name: "studentId",
                style: Get.textTheme.bodyMedium,
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
                onSaved: (val) => _ac.studentId = val,
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: "homeroom",
                      style: Get.textTheme.bodyMedium,
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
                      onSaved: (val) => _ac.homeroom = val,
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 125,
                    child: FormBuilderDropdown(
                      name: "gradeLevel",
                      style: Get.textTheme.bodyMedium,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(label: Text("Grade")),
                      items: const [
                        DropdownMenuItem(value: 9, child: Text("9")),
                        DropdownMenuItem(value: 10, child: Text("10")),
                        DropdownMenuItem(value: 11, child: Text("11")),
                        DropdownMenuItem(value: 12, child: Text("12")),
                      ],
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(errorText: "Required"),
                        ],
                      ),
                      onSaved: (int? val) => _ac.gradeLevel = val,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_fk.currentState!.saveAndValidate()) {
                    if (widget.pc.hasClients) {
                      widget.pc.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeIn,
                      );
                    }
                  }
                },
                child: const Text("Continue"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
