import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/data/models/announ_model.dart';
import 'package:ish_top/ui/admins_panel/tab/announ/pages/all_hiring/all_hiring_screen.dart';
import 'package:ish_top/ui/admins_panel/tab/announ/widgets/search_item.dart';
import 'package:ish_top/ui/admins_panel/tab/announ/widgets/zoom_tap.dart';
import 'package:ish_top/ui/tab/announ/notification/notification_screen.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'page_first.dart';
import 'page_second.dart';

class AdminPageControl extends StatefulWidget {
  const AdminPageControl({super.key});

  @override
  State<AdminPageControl> createState() => _AdminPageControlState();
}

class _AdminPageControlState extends State<AdminPageControl>
    with TickerProviderStateMixin {
  final PageController pageController = PageController();
  bool _isSearching = false;
  final TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();
  late Animation<double> _animation;
  late AnimationController _controller;

  void _toggleAppBar() {
    setState(() {
      if (_isSearching) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      _isSearching = !_isSearching;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 20.h).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          scrolledUnderElevation: 0,
          backgroundColor: CupertinoColors.white.withOpacity(.9),
          title: Text(
            "${"global".tr()} Admin",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 18.sp),
          ),
          centerTitle: true,
          actions: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: IconButton(
                  key: ValueKey<bool>(_isSearching),
                  icon: Icon(
                    _isSearching ? Icons.close : CupertinoIcons.search,
                    size: 16.sp,
                  ),
                  onPressed: _toggleAppBar),
            ),
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
                PullDownMenuItem(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllHiringScreen()));
                  },
                  title: "Barcha e'lonlar",
                  icon: CupertinoIcons.square_stack,
                ),
                PullDownMenuItem(
                  onTap: () {},
                  title: 'Barcha odamlar',
                  icon: CupertinoIcons.person_2,
                )
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
          toolbarHeight:
              56.h - (_animation.value.h - _animation.value.h * 2.44),
          bottom: PreferredSize(
            preferredSize: Size(width, _animation.value),
            child: Column(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SizeTransition(sizeFactor: animation, child: child);
                  },
                  child: _isSearching
                      ? Container(
                          key: const ValueKey('TextField'),
                          color: Colors.transparent,
                          child: SearchItem(
                            controller: controller,
                            focus: focus,
                            valueChanged: (v) {
                              setState(() {});
                            },
                          ),
                        )
                      : Container(
                          key: const ValueKey('EmptyContainer'),
                        ), // empty container when not searching
                ),
                Container(
                  height: 0.6,
                  width: double.infinity,
                  color: CupertinoColors.systemGrey,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: CupertinoColors.systemGrey5,
        body: Column(
          children: [
            10.getH(),
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.transparent,
                  child: TabBar(
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
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  AdminHireScreen(
                    statusAnnoun: StatusAnnoun.active,
                    context: context,
                    controller: controller,
                    focus: focus,
                  ),
                  const AdminPageSecond(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
