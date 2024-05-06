import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../feedback/feedback_screen.dart';
import '../hire/hire_screen.dart';
import '../profile/profile_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key, this.index = 0});

  final int index;

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final List<Widget> screens = [
    const HireScreen(),
    const FeedbackScreen(),
    const ProfileScreen()
  ];

  int activeIndex = 0;

  @override
  void initState() {
    activeIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
          items: [
            BottomNavigationBarItem(
              label: "hires".tr(),
              icon: const Icon(CupertinoIcons.house_fill),
            ),
            BottomNavigationBarItem(
              label: "feedback".tr(),
              icon: const Icon(CupertinoIcons.chat_bubble_2_fill),
            ),
            BottomNavigationBarItem(
              label: "profile".tr(),
              icon: const Icon(CupertinoIcons.profile_circled),
            ),
          ],
        ),
      ),
    );
  }
}
