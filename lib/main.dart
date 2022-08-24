import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/firebase_options.dart';
import 'package:whapp/models/member.dart';
import 'package:whapp/pages/home_page.dart';
import 'package:whapp/pages/login_page.dart';
import 'package:whapp/services/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const WaltonHabitatApp());
}

class WaltonHabitatApp extends StatefulWidget {
  const WaltonHabitatApp({Key? key}) : super(key: key);

  @override
  State<WaltonHabitatApp> createState() => _WaltonHabitatAppState();
}

class _WaltonHabitatAppState extends State<WaltonHabitatApp> {
  final _firebase = FirebaseService.instance;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: _firebase.userChanges(),
      initialData: _firebase.currentUser,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: Builder(
          builder: (context) {
            var user = context.watch<User?>();

            if (user != null) {
              return StreamProvider<Member?>.value(
                value: _firebase.memberChangesById(user.uid),
                initialData: null,
                lazy: true,
                child: GestureDetector(
                  child: const HomePage(),
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
              );
            }

            return const LoginPage();
          },
        ),
      ),
    );
  }
}
