import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/pages/signup_pages/account_form.dart';
import 'package:whapp/pages/signup_pages/contact_form.dart';
import 'package:whapp/pages/signup_pages/student_form.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _pc = PageController();

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      StudentForm(pc: _pc),
      ContactForm(pc: _pc),
      AccountForm(pc: _pc),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        padding: defaultPadding,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pc,
          children: _pages,
        ),
      ),
    );
  }
}
