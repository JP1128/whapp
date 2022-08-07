import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:whapp/pages/home_page.dart';
import 'package:whapp/pages/login_page.dart';

class AuthController extends GetxController {
  static final AuthController instance = Get.find();

  late Rx<User?> _user;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    // not logged in
    if (user == null) {
      Get.offAll(() => const LoginPage());
    } else {
      Get.offAll(() => const HomePage());
    }
  }

  Future<void> createAccount(String email, password) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Account creation failed",
        e.message ?? "",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> login(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login failed",
        e.message ?? "",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
