import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:whapp/controllers/auth_controller.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({
    Key? key,
    required this.pc,
  }) : super(key: key);

  final PageController pc;

  @override
  State<ContactForm> createState() => ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  final AuthController _ac = Get.find();

  final _fk = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _fk,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Contact", style: Get.textTheme.displayLarge),
          const SizedBox(height: 10),
          Text("Enter your contact information", style: Get.textTheme.bodyMedium),
          const SizedBox(height: 50),
          FormBuilderTextField(
            name: "phoneNumber",
            style: Get.textTheme.bodyMedium,
            textCapitalization: TextCapitalization.words,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.telephoneNumber],
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(label: Text("Phone Number")),
            validator: FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(errorText: "Enter your phone number"),
                FormBuilderValidators.numeric(errorText: "Do not include dash (-)"),
                FormBuilderValidators.equalLength(10, errorText: "Enter a valid phone number"),
              ],
            ),
            onSaved: (val) => _ac.phoneNumber = val,
          ),
          const SizedBox(height: 20),
          FormBuilderTextField(
            name: "streetAddress",
            style: Get.textTheme.bodyMedium,
            textCapitalization: TextCapitalization.words,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.streetAddress,
            decoration: const InputDecoration(label: Text("Street Address")),
            validator: FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(errorText: "Enter your street address"),
              ],
            ),
            onSaved: (val) => _ac.streetAddress = val,
          ),
          const SizedBox(height: 20),
          FormBuilderDropdown(
            name: "tShirtSize",
            style: Get.textTheme.bodyMedium,
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
            onSaved: (String? val) => _ac.tShirtSize = val,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Flexible(
                child: OutlinedButton(
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
              ),
              const SizedBox(width: 20),
              Flexible(
                child: ElevatedButton(
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
