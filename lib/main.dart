import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whapp/firebase_options.dart';
import 'package:whapp/pages/login_page.dart';
import 'controllers/auth_controller.dart';
import 'firebase_options.dart';
import 'models/member.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); //
  // .then((value) => Get.put(AuthController()));

  // Prevent landscape mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // runApp(const MyApp());
  runApp(const Test());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appName = "Walton Habitat App";

    return const GetMaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
      alignment: Alignment.center,
      child: const ElevatedButton(
        child: const Text("Add member"),
        onPressed: _test,
      ),
    ));
  }
}

_test() async {
  var db = FirebaseFirestore.instance;

  final ref = db
      .collection("members") //
      .doc('nPeBSfxshYUfwwti6T1BxLLa6MA2')
      .withConverter(
        fromFirestore: Member.fromFirestore,
        toFirestore: (Member m, _) => m.toFirestore(),
      );

  final member = Member(
    uid: "nPeBSfxshYUfwwti6T1BxLLa6MA2",
    role: 1,
    firstName: "Jae",
    lastName: "Park",
    studentId: "1157273",
    homeroom: "Mrs. Ryan",
    gradeLevel: "senior",
    hispanic: false,
    ethnicities: ["asian"],
    cellPhone: "7708834212",
    address: "4153 Moncure Drive, Lilburn, GA, 30047",
    primaryParent: Parent(
      firstName: "Eun",
      lastName: "Park",
      emailAddress: "pk2000love@gmail.com",
      cellPhone: "4045506826",
      work: "medside",
    ),
    tShirtSize: "large",
    tShirtReceived: false,
    duesPaid: false,
  );

  await ref.set(member);
}
