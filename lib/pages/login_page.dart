import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/pages/forgot_password_page.dart';
import 'package:whapp/pages/signup_page.dart';
import 'package:whapp/services/firebase_exceptions.dart';
import 'package:whapp/services/firebase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: defaultPadding,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const SizedBox(height: 30.0),
                        FormBuilder(
                          child: AutofillGroup(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FormBuilderTextField(
                                  name: "email",
                                  controller: _emailController,
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
                                ),
                                const SizedBox(height: 20.0),
                                FormBuilderTextField(
                                  name: "password",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  controller: _passwordController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.password],
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
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(errorText: "Enter your password"),
                                  ]),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ForgotPasswordPage(),
                                            )),
                                        child: Text(
                                          'Forgot Password?',
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30.0),
                                ElevatedButton(
                                  onPressed: () {
                                    var email = _emailController.text.trim();
                                    var password = _passwordController.text.trim();
                                    FirebaseService.instance.login(context, email, password);
                                  },
                                  child: const Text('Log In'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                        },
                        child: Text(
                          "Create account",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      )
                    ],
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
