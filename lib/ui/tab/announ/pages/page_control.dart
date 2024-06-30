import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/blocs/notification/notification_state.dart';
import 'package:ish_top/ui/admins_panel/tab/announ/widgets/zoom_tap.dart';
import 'package:ish_top/ui/tab/announ/notification/notification_screen.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:pull_down_button/pull_down_button.dart';
import '../../../../blocs/notification/notification_bloc.dart';
import '../../../admins_panel/tab/announ/widgets/search_item.dart';
import 'page_first.dart';
import 'page_second.dart';

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
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {},
        builder: (context2, state) {
          return Scaffold(
            backgroundColor: CupertinoColors.systemGrey5,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: false,
                  snap: true,
                  primary: true,
                  elevation: 0,
                  bottom: PreferredSize(
                    preferredSize: Size(width, 30),
                    child: SearchItem(
                        controller: controller,
                        focus: focus,
                        valueChanged: (b) {}),
                  ),
                  scrolledUnderElevation: 0,
                  backgroundColor: CupertinoColors.white.withOpacity(.9),
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
                                builder: (context) =>
                                const NotificationScreen(),
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
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      10.getH(),
                      TabBar(

                        dividerColor: CupertinoColors.systemGrey5,
                        onTap: (v) {
                          if (v == 1) {
                            context.read<AuthBloc>().add(GetAllUsers());
                          }
                        },
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: CupertinoColors.activeBlue,
                        splashBorderRadius: BorderRadius.circular(160),
                        physics: const BouncingScrollPhysics(),
                        labelPadding: const EdgeInsets.only(bottom: 10),
                        labelColor: Colors.white,
                        indicatorWeight: 3.h,
                        overlayColor: WidgetStateColor.transparent,
                        tabs: [
                          Text(
                            "hires".tr(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                            ),
                          ),
                          Text(
                            "workers".tr(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height - 200,
                        child: TabBarView(
                          children: [
                            HireScreen(context: context, focus: focus, controller: controller),
                            const PageSecond()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
