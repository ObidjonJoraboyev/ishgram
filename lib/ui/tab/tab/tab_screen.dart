import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:rive/rive.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key, this.index = 0});

  final int index;

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int activeIndex = 0;

  bool hasInternet = true;
  PageController pageController = PageController();

  @override
  void initState() {
    activeIndex = widget.index;
    super.initState();
  }

  late SMITrigger tapThisPlus;
  late SMITrigger tapOtherPlus;

  late SMITrigger tapThisHome;
  late SMITrigger tapOtherHome;

  late SMITrigger tapThisUser;
  late SMITrigger tapOtherUser;

  late SMITrigger tapThisQuestion;
  late SMITrigger tapOtherQuestion;

  StateMachineController getRiveController(Artboard artBoard) {
    StateMachineController? stateMachineController =
        StateMachineController.fromArtboard(artBoard, "State Machine 1");

    artBoard.addController(stateMachineController!);
    return stateMachineController;
  }

  bool isFirst = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black));

    List<Widget> screens = [
      const PageControl(key: ValueKey(0)),
      AddHireScreen(
        key: const ValueKey(1),
        context: context,
        voidCallback: (v) {
          context.read<ImageBloc>().add(ImageCleanEvent());
          setState(() {});
        },
      ),
      FeedbackScreen(key: const ValueKey(2), userModel: UserModel.initial),
      ProfileScreen(key: const ValueKey(3), context: context),
    ];

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: BlocConsumer<ConnectBloc, ConnectState>(
        listener: (context, state) {
          hasInternet = state.hasInternet;
        },
        builder: (context, state) {
          return Scaffold(
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: screens[activeIndex],
            ),
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                unselectedItemColor: CupertinoColors.systemGrey,
                selectedFontSize: 10.sp,
                unselectedFontSize: 10.sp,
                selectedItemColor: CupertinoColors.activeBlue,
                backgroundColor: CupertinoColors.white,
                currentIndex: activeIndex,
                useLegacyColorScheme: true,
                onTap: (v) async {
                  if (v != 3) {
                    tapOtherUser.fire();
                  } else if (v == 3) {
                    tapThisUser.fire();
                  }
                  if (v != 2) {
                    tapOtherQuestion.fire();
                  } else if (v == 2) {
                    tapThisQuestion.fire();
                  }

                  if (v != 0) {
                    tapOtherHome.fire();
                  } else if (v == 0) {
                    tapThisHome.fire();
                  }
                  if (v != 1) {
                    tapOtherPlus.fire();
                  } else if (v == 1) {
                    tapThisPlus.fire();
                  }
                  setState(() {
                    activeIndex = v;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    label: "hires".tr(),
                    icon: Transform.scale(
                      scale: 1.05,
                      child: SizedBox(
                        width: 20.sp,
                        height: 20.sp,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Transform.scale(
                            scale: 1.2,
                            child: RiveAnimation.asset(
                              "assets/rives/home.riv",
                              useArtboardSize: false,
                              onInit: (artboard) {
                                StateMachineController controller =
                                    getRiveController(artboard);
                                tapThisHome = controller.findSMI("tap_this")
                                    as SMITrigger;
                                tapOtherHome = controller.findSMI("tap_other")
                                    as SMITrigger;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: "add_hire".tr(),
                    icon: SizedBox(
                      width: 20.sp,
                      height: 20.sp,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: RiveAnimation.asset(
                          "assets/rives/plus.riv",
                          useArtboardSize: true,
                          onInit: (artboard) {
                            StateMachineController controller =
                                getRiveController(artboard);
                            tapThisPlus =
                                controller.findSMI("tap_this") as SMITrigger;
                            tapOtherPlus =
                                controller.findSMI("tap_other") as SMITrigger;
                          },
                        ),
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: "help".tr(),
                    icon: SizedBox(
                      width: 20.sp,
                      height: 20.sp,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: RiveAnimation.asset(
                          "assets/rives/question_last.riv",
                          useArtboardSize: true,
                          onInit: (artboard) {
                            StateMachineController controller =
                                getRiveController(artboard);
                            tapThisQuestion =
                                controller.findSMI("tap_this") as SMITrigger;
                            tapOtherQuestion =
                                controller.findSMI("tap_other") as SMITrigger;
                          },
                        ),
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: "profile".tr(),
                    icon: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 20.sp,
                        width: 20.sp,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: activeIndex == 3
                              ? CupertinoColors.activeBlue
                              : CupertinoColors.systemGrey,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 16.sp,
                            height: 16.sp,
                            child: RiveAnimation.asset(
                              "assets/rives/user.riv",
                              useArtboardSize: true,
                              onInit: (artboard) {
                                StateMachineController controller =
                                    getRiveController(artboard);
                                tapThisUser = controller.findSMI("tap_this")
                                    as SMITrigger;
                                tapOtherUser = controller.findSMI("tap_other")
                                    as SMITrigger;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
