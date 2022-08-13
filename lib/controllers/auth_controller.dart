import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/member.dart';
import 'package:whapp/models/parent.dart';
import 'package:whapp/pages/home_page.dart';
import 'package:whapp/pages/login_page.dart';

class AuthController extends GetxController {
  static final AuthController instance = Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  late Rx<User?> firebaseUser;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _initialScreen);
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
  }

  _initialScreen(User? user) {
    if (user == null) {
      Get.offAllNamed('/login');
    } else {
      Get.offAllNamed('/home');
    }
  }

  Future<User?> get getUser async => _auth.currentUser;

  Future<Member?> get getMember async {
    var user = firebaseUser.value;

    if (user != null) {
      var uid = user.uid;
      return _db //
          .collection('members')
          .doc(uid.toString())
          .get()
          .then((data) {
        var parentData = data['primaryParent'];
        var parent = parentData != null
            ? Parent(
                fullName: parentData['fullName'],
                emailAddress: parentData['emailAddress'],
                cellPhone: parentData['cellPhone'],
                work: parentData['work'],
              )
            : null;

        var ethnicitiesData = data['ethnicities'];
        var ethnicities = ethnicitiesData is Iterable //
            ? List<String>.from(ethnicitiesData)
            : null;

        return Member(
          uid: uid,
          emailAddress: user.email!,
          photoURL: user.photoURL!,
          points: data['points'],
          minutes: data['minutes'],
          collection: data['collection'].toDouble(),
          role: data['role'],
          fullName: data['fullName'],
          studentId: data['studentId'],
          homeroom: data['homeroom'],
          gradeLevel: data['gradeLevel'],
          hispanic: data['hispanic'],
          ethnicities: ethnicities,
          cellPhone: data['cellPhone'],
          address: data['address'],
          primaryParent: parent,
          tShirtSize: data['tShirtSize'],
          tShirtReceived: data['tShirtReceived'],
          duesPaid: data['duesPaid'],
        );
      });
    }

    return Future.error(
      Exception('Could not retrieve member instance associated with the current user'),
    );
  }

  Future<void> login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      showError("Login failed", e.message ?? "");
    }
  }

  Future<void> createAccount() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      showError("Account creation failed", e.message ?? "");
    }
  }

  Future<void> sendPasswordResetEmail() async {
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      showSuccess("Success", "Password reset email was sent!");
      Get.back();
    } on FirebaseAuthException catch (e) {
      showError("Password reset failed", e.message ?? "");
    }
  }

  Future<void> logout() async {
    emailController.clear();
    passwordController.clear();
    _auth.signOut();
    update();
  }
}
