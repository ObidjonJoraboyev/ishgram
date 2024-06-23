import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/connectivity/connectivity_bloc.dart';
import 'package:ish_top/blocs/connectivity/connectivity_state.dart';
import 'package:ish_top/blocs/image/image_bloc.dart';
import 'package:ish_top/blocs/image/image_event.dart';
import 'package:ish_top/data/models/user_model.dart';
import 'package:ish_top/ui/tab/announ/add_announ/add_announ_screen.dart';
import 'package:ish_top/ui/tab/announ/pages/page_control.dart';
import 'package:ish_top/ui/tab/feedback/feedback_screen.dart';
import 'package:ish_top/ui/tab/profile/profile_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key, this.index = 0});

  final int index;

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int activeIndex = 0;

  bool hasInternet=true;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const PageControl(),
      AddHireScreen(
        context: context,
        voidCallback: (v) {
          activeIndex = 0;
          context.read<ImageBloc>().add(ImageCleanEvent());
          setState(() {});
        },
      ),
      FeedbackScreen(userModel: UserModel.initial),
      ProfileScreen(
        context: context,
      ),
    ];
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: BlocConsumer<ConnectBloc, ConnectState>(
        listener: (context, state) {
          hasInternet=state.hasInternet;

        },
        builder: (context, state) {
          return Scaffold(
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
            floatingActionButton:!state.hasInternet? const Text("Internet mavjud emas",style: TextStyle(fontSize: 24,color: Colors.red),):const SizedBox(),
          );
        },
      ),
    );
  }
}
