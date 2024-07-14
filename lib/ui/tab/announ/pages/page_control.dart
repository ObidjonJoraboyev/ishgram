import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/notification/notification_state.dart';
import 'package:ish_top/ui/admins_panel/tab/announ/widgets/zoom_tap.dart';
import 'package:ish_top/ui/tab/announ/notification/notification_screen.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:pull_down_button/pull_down_button.dart';
import '../../../../blocs/notification/notification_bloc.dart';
import '../../../admins_panel/tab/announ/widgets/search_item.dart';
import 'page_first.dart';

class PageControl extends StatefulWidget {
  const PageControl({super.key});

  @override
  State<PageControl> createState() => _PageControlState();
}

class _PageControlState extends State<PageControl>
    with TickerProviderStateMixin {
  final PageController pageController = PageController();
  final TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    controller.dispose();
    focus.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {},
      builder: (context2, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            backgroundColor: Colors.white.withOpacity(.8),
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size(width, 30.h),
              child: Column(
                children: [
                  SearchItem(
                      controller: controller,
                      focus: focus,
                      valueChanged: (b) {}),
                  10.getH(),
                  Container(
                    height: 0.6.h,
                    width: double.infinity,
                    color: CupertinoColors.systemGrey,
                  ),
                ],
              ),
            ),
            scrolledUnderElevation: 0,
            title: Text(
              "global".tr(),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 19.sp),
            ),
            centerTitle: true,
            actions: [
              PullDownButton(
                itemBuilder: (context) => [
                  PullDownMenuItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
                    },
                    title: "notifications".tr(),
                    icon: Icons.notifications_active_outlined,
                  ),
                  PullDownMenuItem(
                    onTap: () {},
                    title: "Filter",
                    icon: Icons.filter_alt_outlined,
                  ),
                ],
                buttonBuilder: (w, d) {
                  return ScaleOnPress(
                    onTap: () async {
                      d();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: const Icon(Icons.more_vert),
                    ),
                  );
                },
              ),
            ],
          ),
          backgroundColor: CupertinoColors.systemGrey5,
          body: HireScreen(
              context: context, focus: focus, controller: controller),
        );
      },
    );
  }
}
