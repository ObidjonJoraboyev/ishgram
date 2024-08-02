import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/announ_bloc/announ_bloc.dart';
import 'package:ish_top/blocs/announ_bloc/announ_event.dart';
import 'package:ish_top/blocs/notification/notification_bloc.dart';
import 'package:ish_top/blocs/notification/notification_state.dart';
import 'package:ish_top/ui/tab/announ/search_screen.dart';
import 'package:ish_top/ui/tab/announ/widgets/zoom_tap.dart';
import 'package:ish_top/ui/tab/announ/notification/notification_screen.dart';
import 'package:pull_down_button/pull_down_button.dart';
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
            scrolledUnderElevation: 0,
            title: Text(
              "global".tr(),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 18.sp,
              ),
            ),
            actions: [
              PullDownButton(
                itemBuilder: (context) => [
                  PullDownMenuItem(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      ).then((c) {
                        setState(() {
                          context.read<AnnounBloc>().add(AnnounGetEvent());
                        });
                      });
                    },
                    title: "search".tr(),
                    icon: CupertinoIcons.search,
                  ),
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
                    icon: CupertinoIcons.bell,
                  ),
                  PullDownMenuItem(
                    onTap: () {},
                    title: "Filter",
                    icon: CupertinoIcons.slider_horizontal_3,
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
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size(
                MediaQuery.sizeOf(context).width,
                0.6.h,
              ),
              child: Container(
                height: 0.6.h,
                width: double.infinity,
                color: CupertinoColors.systemGrey,
              ),
            ),
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            backgroundColor: Colors.white.withOpacity(.9),
          ),
          backgroundColor: CupertinoColors.white,
          body: HireScreen(
              context: context, focus: focus, controller: controller),
        );
      },
    );
  }
}
