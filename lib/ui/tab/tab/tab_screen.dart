import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../feedback/feedback_screen.dart';
import '../hire/hire_screen.dart';
import '../history/history_screen.dart';
import '../profile/profile_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final List<Widget> screens = const [
    HireScreen(),
    HistoryScreen(),
    FeedbackScreen(),
    ProfileScreen()
  ];

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[activeIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: CupertinoColors.systemGrey6,
        selectedItemColor: CupertinoColors.activeBlue,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: activeIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (v) {
          activeIndex = v;
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(
            label: "E'lonlar",
            icon: Icon(CupertinoIcons.house_fill),
          ),
          BottomNavigationBarItem(
            label: "Tarix",
            icon: Icon(Icons.history),
          ),
          BottomNavigationBarItem(
            label: "Fikr",
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(CupertinoIcons.profile_circled),
          ),
        ],
      ),
    );
  }
}
