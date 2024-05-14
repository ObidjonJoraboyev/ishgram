import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/data/models/user_model.dart';
import '../../auth/auth_screen.dart';
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
  final List<Widget> screens = [
    const HireScreen(),
    const AddHireScreen(),
    FeedbackScreen(
      userModel: UserModel.initial,
    ),
    const ProfileScreen(),
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
            if (v == 1 &&
                StorageRepository.getString(key: "userNumber").isEmpty) {
              setState(() {});
              showDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("Login"),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text(
                        'Orqaga',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: CupertinoColors.activeBlue),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.activeBlue),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthScreen()),
                            (route) => false);
                      },
                    ),
                  ],
                  content: const Text(
                    "Siz e'lon qo'shish uchun login qilmagansiz.",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            } else {
              activeIndex = v;
              setState(() {});
            }
          },
          items: [
            BottomNavigationBarItem(
              label: "hires".tr(),
              icon: const Icon(CupertinoIcons.house_fill),
            ),
            const BottomNavigationBarItem(
              label: "Elon qo'shish",
              icon: Icon(CupertinoIcons.add_circled),
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
