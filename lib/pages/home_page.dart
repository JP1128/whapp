import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:whapp/controllers/auth_controller.dart';
import 'package:whapp/pages/home_pages/event_page.dart';
import 'package:whapp/pages/home_pages/history_page.dart';
import 'package:whapp/pages/home_pages/profile_page.dart';
import 'package:whapp/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final AuthController _ac = Get.find();

  var index = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: index.value,
            onTap: (i) => index.value = i,
            items: [
              const BottomNavigationBarItem(
                label: "Home",
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
              ),
              const BottomNavigationBarItem(
                label: "History",
                icon: Icon(Icons.receipt_outlined),
                activeIcon: Icon(Icons.receipt_rounded),
              ),
              if (_ac.isBoard())
                const BottomNavigationBarItem(
                  label: "Directory",
                  icon: const Icon(Icons.search_outlined),
                  activeIcon: const Icon(Icons.search_rounded),
                ),
              const BottomNavigationBarItem(
                label: "Profile",
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person_rounded),
              ),
            ],
          )),
      body: Obx(
        () => [
          EventPage(),
          HistoryPage(),
          if (_ac.isBoard()) SearchPage(),
          ProfilePage(),
        ][index.value],
      ),
    );
  }
}
