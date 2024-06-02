import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/announcement_bloc/hire_event.dart';
import 'package:ish_top/data/models/announcement_model.dart';
import 'package:ish_top/ui/tab/profile/my_announcements/widgets/my_announs_item.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import '../../../../blocs/announcement_bloc/hire_bloc.dart';
import '../../../../blocs/announcement_bloc/hire_state.dart';
import '../../../../blocs/auth/auth_bloc.dart';
import '../../../../blocs/auth/auth_state.dart';

class MyAnnouncements extends StatefulWidget {
  const MyAnnouncements({super.key});

  @override
  State<MyAnnouncements> createState() => _MyAnnouncementsState();
}

class _MyAnnouncementsState extends State<MyAnnouncements> {
  @override
  void initState() {
    context.read<AnnouncementBloc>().add(AnnounListGetEvent(
        announcementDocs: context.read<AuthBloc>().state.userModel.allHiring));
    super.initState();
  }

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnnouncementBloc, AnnounState>(
      listener: (context, announState) {},
      builder: (context, announState) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, authState) {},
          builder: (context, authState) {
            return DefaultTabController(
              length: 3,
              initialIndex: 0,
              child: Scaffold(
                backgroundColor: CupertinoColors.systemGrey5,
                appBar: AppBar(
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
                  scrolledUnderElevation: 0,
                  flexibleSpace: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  backgroundColor: Colors.white.withOpacity(.9),
                  title: Text("my_announcements".tr()),
                ),
                body: Column(
                  children: [
                    5.getH(),
                    TabBar(
                      dividerColor: CupertinoColors.systemGrey5,
                      onTap: (v) {
                        activeIndex = v;
                        setState(() {});
                      },
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: CupertinoColors.activeBlue,
                      splashBorderRadius: BorderRadius.circular(160),
                      physics: const BouncingScrollPhysics(),
                      labelPadding: const EdgeInsets.only(bottom: 10),
                      labelColor: Colors.white,
                      indicatorWeight: 2.h,
                      overlayColor: WidgetStateColor.transparent,
                      tabs: [
                        Text(
                          "Active",
                          style: TextStyle(
                            color: CupertinoColors.activeBlue,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          "Finished",
                          style: TextStyle(
                            color: CupertinoColors.activeOrange,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          "Returned",
                          style: TextStyle(
                            color: CupertinoColors.systemRed,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: TabBarView(
                          children: [
                            ListView(
                              children: [
                                ...List.generate(
                                    announState.myHires
                                        .where((test) =>
                                            test.status ==
                                            StatusAnnouncement.pure)
                                        .toList()
                                        .length, (index) {
                                  return MyAnnounItem(
                                      hires: announState.myHires
                                          .where((v) =>
                                              v.status ==
                                              StatusAnnouncement.pure)
                                          .toList()[index],
                                      voidCallback: () {},
                                      scrollController: ScrollController(),
                                      context1: context);
                                })
                              ],
                            ),
                            ListView(
                              children: [
                                ...List.generate(
                                    announState.myHires
                                        .where((test) =>
                                            test.status ==
                                            StatusAnnouncement.done)
                                        .toList()
                                        .length, (index) {
                                  return MyAnnounItem(
                                      hires: announState.myHires
                                          .where((v) =>
                                              v.status ==
                                              StatusAnnouncement.done)
                                          .toList()[index],
                                      voidCallback: () {},
                                      scrollController: ScrollController(),
                                      context1: context);
                                })
                              ],
                            ),
                            ListView(
                              children: [
                                ...List.generate(
                                    announState.myHires
                                        .where((test) =>
                                            test.status ==
                                            StatusAnnouncement.returned)
                                        .toList()
                                        .length, (index) {
                                  return MyAnnounItem(
                                      hires: announState.myHires
                                          .where((v) =>
                                              v.status ==
                                              StatusAnnouncement.returned)
                                          .toList()[index],
                                      voidCallback: () {},
                                      scrollController: ScrollController(),
                                      context1: context);
                                })
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
