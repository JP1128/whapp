import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whapp/models/event.dart';
import 'package:whapp/models/member.dart';
import 'package:whapp/pages/event_pages/event_creation_page.dart';
import 'package:whapp/pages/home_pages/directory_page.dart';
import 'package:whapp/pages/home_pages/event_page.dart';
import 'package:whapp/pages/home_pages/profile_page.dart';
import 'package:whapp/services/firebase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();

  var _index = 0;

  @override
  Widget build(BuildContext context) {
    var member = Provider.of<Member?>(context);

    if (member == null) {
      return const Center(child: CircularProgressIndicator());
    }

    var isBoard = member.role <= 2;

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(parent: const ClampingScrollPhysics()),
        onPageChanged: (i) => setState(() => _index = i),
        controller: _pageController,
        children: [
          StreamProvider<List<Event>?>.value(
            value: FirebaseService.instance.streamEvents(),
            initialData: const [],
            child: EventPage(),
          ),
          Scaffold(
            appBar: AppBar(
              title: const Text("History"),
            ),
          ),
          if (isBoard) const DirectoryPage(),
          ProfilePage(member),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) {
          _pageController.animateToPage(
            i,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
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
          if (isBoard)
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
      ),
    );
  }
}
