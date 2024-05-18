import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ish_top/data/models/user_model.dart';
import '../announcement/add_announcement/add_announcement_screen.dart';
import '../announcement/announcement_screen.dart';
import '../feedback/feedback_screen.dart';
import '../profile/profile_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key, this.index = 0});

  final int index;

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int activeIndex = 0;

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const HireScreen(),
      AddHireScreen(
        voidCallback: (v) {
          activeIndex = 0;
          setState(() {});
        },
      ),
      FeedbackScreen(userModel: UserModel.initial),
      const ProfileScreen(),
    ];
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IndexedStack(index: activeIndex, children: screens),
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
              label: "add_hire".tr(),
              icon: const Icon(CupertinoIcons.add_circled),
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
