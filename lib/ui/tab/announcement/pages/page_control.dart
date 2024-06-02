import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/ui/tab/announcement/pages/page_first.dart';
import 'package:ish_top/ui/tab/announcement/pages/page_second.dart';
import '../../../../utils/size/size_utils.dart';
import '../widgets/search_item.dart';

class PageControl extends StatefulWidget {
  const PageControl({super.key});

  @override
  State<PageControl> createState() => _PageControlState();
}

class _PageControlState extends State<PageControl>
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
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;
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
            "global".tr(),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 20.sp),
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
                  icon:
                      Icon(_isSearching ? Icons.close : CupertinoIcons.search),
                  onPressed: _toggleAppBar),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
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
                  HireScreen(
                    context: context,
                    controller: controller,
                    focus: focus,
                  ),
                  const PageSecond()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
