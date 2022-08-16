import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/controllers/events_controller.dart';
import 'package:whapp/controllers/storage_controller.dart';
import 'package:whapp/firebase_options.dart';
import 'package:whapp/pages/forgot_password_page.dart';
import 'package:whapp/pages/home_page.dart';
import 'package:whapp/pages/home_pages/event_creation_page.dart';
import 'package:whapp/pages/login_page.dart';
import 'package:whapp/pages/home_pages/profile_page.dart';
import 'package:whapp/pages/signup_page.dart';
import 'package:whapp/pages/splash_page.dart';
import 'controllers/auth_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    Get.put(AuthController());
    Get.put(StorageController());
    Get.put(EventsController());
  });

  // Prevent landscape mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      defaultTransition: Transition.native,
      initialRoute: "/",
      getPages: [
        GetPage(name: '/', page: () => const SplashPage()),
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          transition: Transition.fade,
        ),
        GetPage(
          name: '/signup',
          page: () => const SignupPage(),
          transition: Transition.downToUp,
        ),
        GetPage(name: '/create_event', page: () => EventCreationPage()),
        GetPage(name: '/forgot', page: () => const ForgotPasswordPage()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
      ],
    );
  }
}
