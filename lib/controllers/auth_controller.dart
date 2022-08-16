import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/member.dart';

class AuthController extends GetxController {
  static final AuthController instance = Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Login & Registration
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Registration
  // Student information
  String? fullName;
  String? studentId;
  String? homeroom;
  int? gradeLevel;

  // Contact information
  String? phoneNumber;
  String? streetAddress;
  String? tShirtSize;

  late Rx<User?> firebaseUser;
  late Rx<Member?> member;

  @override
  void onInit() {
    super.onInit();
    member = Rx<Member?>(null);
  }

  @override
  void onReady() async {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthStateChanges);
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  _handleAuthStateChanges(User? user) async {
    if (user == null) {
      Get.offAllNamed('/login');
    } else {
      member.bindStream(streamMember());
      Get.offAllNamed('/home');
    }
  }

  Future<User?> get getUser async => _auth.currentUser;

  Stream<Member?> streamMember() {
    var user = firebaseUser.value;

    if (user == null) return const Stream.empty();

    return _db //
        .collection("members")
        .doc(user.uid)
        .snapshots()
        .map((data) => Member(
              uid: user.uid,
              emailAddress: user.email!, // signed in
              photoURL: user.photoURL,
              role: data['role'],

              points: data['points'],
              minutes: data['minutes'],
              collection: data['collection'].toDouble(),

              fullName: data['fullName'],
              studentId: data['studentId'],
              homeroom: data['homeroom'],
              gradeLevel: data['gradeLevel'],

              phoneNumber: data['phoneNumber'],
              streetAddress: data['streetAddress'],

              tShirtSize: data['tShirtSize'],
              tShirtReceived: data['tShirtReceived'],
              duesPaid: data['duesPaid'],
            ));
  }

  Future<Member?> get getMember async {
    var user = firebaseUser.value;

    if (user == null) return null;

    return await _db //
        .collection('members')
        .doc(user.uid.toString())
        .get()
        .then((data) => Member(
              uid: user.uid,
              emailAddress: user.email!, // signed in
              photoURL: user.photoURL,
              role: data['role'],

              points: data['points'],
              minutes: data['minutes'],
              collection: data['collection'].toDouble(),

              fullName: data['fullName'],
              studentId: data['studentId'],
              homeroom: data['homeroom'],
              gradeLevel: data['gradeLevel'],

              phoneNumber: data['phoneNumber'],
              streetAddress: data['streetAddress'],

              tShirtSize: data['tShirtSize'],
              tShirtReceived: data['tShirtReceived'],
              duesPaid: data['duesPaid'],
            ));
  }

  bool isBoard() => member.value != null ? member.value!.role <= 2 : false;

  bool isAdmin() => member.value != null ? member.value!.role == 1 : false;

  Future<void> createMember(Member member) async {
    var user = firebaseUser.value;

    if (user != null) {
      await _db //
          .collection('members')
          .doc(user.uid.toString())
          .set({
        "uid": user.uid,
        "emailAddress": member.emailAddress,
        "photoURL": member.photoURL,
        "role": member.role,
        "points": member.points,
        "minutes": member.minutes,
        "collection": member.collection,
        "fullName": member.fullName,
        "studentId": member.studentId,
        "homeroom": member.homeroom,
        "gradeLevel": member.gradeLevel,
        "phoneNumber": member.phoneNumber,
        "streetAddress": member.streetAddress,
        "tShirtSize": member.tShirtSize,
        "tShirtReceived": member.tShirtReceived,
        "duesPaid": member.duesPaid,
      });
    }
  }

  Future<void> login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      showError("Login failed", e.message ?? "");
    }
  }

  Future<void> createAccount() async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((uc) => createMember(Member(
                uid: uc.user!.uid,
                emailAddress: uc.user!.email!,
                photoURL: uc.user!.photoURL,
                role: 3,
                points: 0,
                minutes: 0,
                collection: 0,
                fullName: fullName!,
                studentId: studentId!,
                homeroom: homeroom!,
                gradeLevel: gradeLevel!,
                phoneNumber: phoneNumber!,
                streetAddress: streetAddress!,
                tShirtSize: tShirtSize!,
                tShirtReceived: false,
                duesPaid: false,
              )));
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
    confirmPasswordController.clear();
    _auth.signOut();
    update();
  }
}
