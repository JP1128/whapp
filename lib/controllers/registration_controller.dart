import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  static final RegistrationController instance = Get.find();

  final studentFormKey = GlobalKey<FormBuilderState>();
  final contactFormKey = GlobalKey<FormBuilderState>();
  final accountFormKey = GlobalKey<FormBuilderState>();
}
