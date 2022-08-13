import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/controllers/auth_controller.dart';
import 'package:whapp/widgets/input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController ac = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        padding: defaultPadding,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: SizedBox.square(
                    dimension: 75,
                    child: Image(
                      image: AssetImage("assets/habitat_logo.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Welcome Back!',
                    style: Get.textTheme.displayLarge,
                  ),
                  Text(
                    'Login with your email',
                    style: Get.textTheme.displayMedium,
                  ),
                  const SizedBox(height: 30.0),
                  AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        EmailInputField(
                          controller: ac.emailController,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 10.0),
                        PasswordInputField(
                          controller: ac.passwordController,
                          textInputAction: TextInputAction.done,
                          autoFillHints: AutofillHints.password,
                          confirmPassword: false,
                        ),
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Get.toNamed("/forgot"),
                                child: Text(
                                  'Forgot Password?',
                                  style: Get.textTheme.titleSmall!.copyWith(color: primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        ElevatedButton(
                          onPressed: () => AuthController.instance.login(),
                          child: const Text('Log In'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: Get.textTheme.titleSmall,
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed("/signup/1"),
                    child: Text(
                      "Create Account",
                      style: Get.textTheme.titleSmall!.copyWith(
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
