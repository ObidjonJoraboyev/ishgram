import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/announ_bloc/announ_bloc.dart';
import 'package:ish_top/blocs/announ_bloc/announ_event.dart';
import 'package:ish_top/blocs/announ_bloc/announ_state.dart';
import 'package:ish_top/blocs/user/user_bloc.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/data/models/announ_model.dart';
import 'package:ish_top/ui/tab/profile/my_announs/my_announcements.dart';
import 'package:ish_top/utils/size/size_utils.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.context});

  final BuildContext context;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    context.read<AnnounBloc>().add(AnnounGetUserIdEvent(
        userId: context.read<UserBloc>().state.userModel.docId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnnounBloc, AnnounState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
                backgroundColor: CupertinoColors.systemGrey6,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        CupertinoIcons.back,
                        size: 24.sp,
                      )),
                  scrolledUnderElevation: 0,
                  title: Text(
                    "my_announcements".tr(),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 18.sp),
                  ),
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
                body: RefreshIndicator(
                  onRefresh: () async {
                    context.read<AnnounBloc>().add(AnnounGetEvent());
                  },
                  child: ListView(
                    children: [
                      10.getH(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Row(
                          children: [
                            Expanded(
                                child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.push(
                                  widget.context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyAnnouncements(
                                        statusAnnoun: StatusAnnoun.active),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 15.w, bottom: 8.h, top: 8.h),
                                margin: EdgeInsets.symmetric(horizontal: 8.w),
                                decoration: BoxDecoration(
                                    color: CupertinoColors.activeBlue,
                                    borderRadius: BorderRadius.circular(16.r)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.myHires
                                          .where((toElement) =>
                                              toElement.status ==
                                              StatusAnnoun.active)
                                          .toList()
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    10.getH(),
                                    Text(
                                      "Active",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            )),
                            Expanded(
                                child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.push(
                                    widget.context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyAnnouncements(
                                                statusAnnoun:
                                                    StatusAnnoun.waiting)));
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 15.w, bottom: 8.h, top: 8.h),
                                margin: EdgeInsets.symmetric(horizontal: 8.w),
                                decoration: BoxDecoration(
                                    color: CupertinoColors.systemOrange,
                                    borderRadius: BorderRadius.circular(16.r)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.myHires
                                          .where((toElement) =>
                                              toElement.status ==
                                              StatusAnnoun.waiting)
                                          .toList()
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    10.getH(),
                                    Text(
                                      "waiting".tr(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                      10.getH(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Row(
                          children: [
                            Expanded(
                                child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.push(
                                    widget.context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyAnnouncements(
                                                statusAnnoun:
                                                    StatusAnnoun.done)));
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 15.w, bottom: 8.h, top: 8.h),
                                margin: EdgeInsets.symmetric(horizontal: 8.w),
                                decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey,
                                    borderRadius: BorderRadius.circular(16.r)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.myHires
                                          .where((toElement) =>
                                              toElement.status ==
                                              StatusAnnoun.done)
                                          .toList()
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    10.getH(),
                                    Text(
                                      "Finished",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            )),
                            Expanded(
                                child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.push(
                                    widget.context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyAnnouncements(
                                                statusAnnoun:
                                                    StatusAnnoun.returned)));
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 15.w, bottom: 8.h, top: 8.h),
                                margin: EdgeInsets.symmetric(horizontal: 8.w),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.destructiveRed,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.myHires
                                          .where((toElement) =>
                                              toElement.status ==
                                              StatusAnnoun.returned)
                                          .toList()
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    10.getH(),
                                    Text(
                                      "Returned",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.sp,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            if (state.status == FormStatus.loading)
              Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 30.sp,
                            height: 30.sp,
                            child: const CircularProgressIndicator(
                              strokeCap: StrokeCap.round,
                              backgroundColor: Colors.grey,
                              color: Colors.white,
                            )),
                        15.getH(),
                        Material(
                          color: Colors.transparent,
                          child: Text(
                            "checking".tr(),
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                shadows: [
                                  BoxShadow(
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(.3))
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
