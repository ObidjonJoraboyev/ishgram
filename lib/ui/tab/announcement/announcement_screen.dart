import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/connectivity/connectivity_bloc.dart';
import 'package:ish_top/blocs/connectivity/connectivity_state.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/ui/tab/announcement/widgets/hiring_item.dart';
import 'package:ish_top/ui/tab/announcement/widgets/search_item.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import '../../../blocs/announcement_bloc/hire_bloc.dart';

class HireScreen extends StatefulWidget {
  const HireScreen({super.key, required this.context});
  final BuildContext context;
  @override
  State<HireScreen> createState() => _HireScreenState();
}

class _HireScreenState extends State<HireScreen> with TickerProviderStateMixin {
  FocusNode focus = FocusNode();
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void dispose() {
    scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  int activeIndex = 0;

  bool check = false;
  bool _isSearching = false;

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
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: CupertinoColors.systemGrey5,
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
            "hires".tr(),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18.sp),
          ),
          centerTitle: false,
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
        body: BlocConsumer<ConnectBloc, ConnectState>(
          listener: (context, state) {},
          builder: (context, state) {
            return BlocBuilder<AnnouncementBloc, List<AnnouncementModel>>(
              builder: (BuildContext context, List<AnnouncementModel> state) {
                List<AnnouncementModel> hires = state
                    .where((element) => element.title
                        .toLowerCase()
                        .contains(controller.text.toLowerCase()))
                    .toList();
                return ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: HiringItem(
                        context1: widget.context,
                        voidCallback: () {
                          focus.unfocus();
                          setState(() {});
                        },
                        hires: hires,
                        scrollController: scrollController,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
