import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whapp/constants/style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget _buildInputFieldContainer(TextField inputField) => Container(
        height: 55.0,
        alignment: Alignment.centerLeft,
        decoration: inputBoxStyle,
        child: inputField,
      );

  Widget _buildEmailInputField() => _buildInputFieldContainer(
        TextField(
          obscureText: false,
          keyboardType: TextInputType.emailAddress,
          style: inputFieldTextStyle,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: Colors.black45,
            ),
            hintText: 'Email address',
          ),
        ),
      );

  Widget _buildPasswordInputField() => _buildInputFieldContainer(
        TextField(
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          style: inputFieldTextStyle,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.black,
            ),
            hintText: 'Password',
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 50.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome!',
              style: poppins(33, FontWeight.w600),
            ),
            Text(
              'Glad to have you on board',
              style: poppins(20, FontWeight.w600),
            ),
            const SizedBox(height: 30.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildEmailInputField(),
                const SizedBox(height: 10.0),
                _buildPasswordInputField(),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => print("Forgot Password Button Pressed"),
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF3A3A3A),
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => print('Login Button Pressed'),
                    child: Text(
                      'Log in',
                      style: poppins(15, FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
