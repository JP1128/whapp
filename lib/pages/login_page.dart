import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _ac = Get.find();
  final _hidePassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: defaultPadding,
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
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
            SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                      FormBuilder(
                        child: AutofillGroup(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
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
                              const SizedBox(height: 10.0),
                              Obx(() => FormBuilderTextField(
                                    name: "password",
                                    style: Get.textTheme.bodyMedium,
                                    controller: _ac.passwordController,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    textInputAction: TextInputAction.done,
                                    autofillHints: const [AutofillHints.password],
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
                                    ]),
                                  )),
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
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: Get.textTheme.titleSmall,
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed("/signup"),
                        child: Text(
                          "Create Account",
                          style: Get.textTheme.titleSmall!.copyWith(
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
