import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/image/image_bloc.dart';
import 'package:ish_top/blocs/image/image_event.dart';
import 'package:ish_top/data/models/user_model.dart';
import 'package:ish_top/ui/admins_panel/tab/announ/add_announ/add_announ_screen.dart';
import 'package:ish_top/ui/admins_panel/tab/announ/pages/page_control.dart';
import 'package:ish_top/ui/admins_panel/tab/feedback/feedback_screen.dart';
import 'package:ish_top/ui/admins_panel/tab/profile/profile_screen.dart';

class AdminTabScreen extends StatefulWidget {
  const AdminTabScreen({super.key, this.index = 0});

  final int index;

  @override
  State<AdminTabScreen> createState() => _AdminTabScreenState();
}

class _AdminTabScreenState extends State<AdminTabScreen> {
  int activeIndex = 0;

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const AdminPageControl(),
      AdminAddHireScreen(
        context: context,
        voidCallback: (v) {
          activeIndex = 0;
          context.read<ImageBloc>().add(ImageCleanEvent());
          setState(() {});
        },
      ),
      AdminFeedbackScreen(userModel: UserModel.initial),
      AdminProfileScreen(
        context: context,
      ),
    ];
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
          selectedFontSize: 13.sp,
          unselectedFontSize: 12.sp,
          currentIndex: activeIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (v) {
            activeIndex = v;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              label: "hires".tr(),
              icon: Icon(
                CupertinoIcons.house_fill,
                size: 20.sp,
              ),
            ),
            BottomNavigationBarItem(
              label: "add_hire".tr(),
              icon: Icon(CupertinoIcons.add_circled, size: 20.sp),
            ),
            BottomNavigationBarItem(
              label: "feedback".tr(),
              icon: Icon(
                CupertinoIcons.chat_bubble_2_fill,
                size: 20.sp,
              ),
            ),
            BottomNavigationBarItem(
              label: "profile".tr(),
              icon: Icon(
                CupertinoIcons.profile_circled,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
