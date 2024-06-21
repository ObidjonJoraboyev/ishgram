import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/data/models/announ_model.dart';
import 'package:ish_top/ui/admins_panel/tab/announ/pages/page_first.dart';
import 'package:ish_top/utils/size/size_utils.dart';

class AllHiringScreen extends StatefulWidget {
  const AllHiringScreen({super.key});

  @override
  State<AllHiringScreen> createState() => _AllHiringScreenState();
}

class _AllHiringScreenState extends State<AllHiringScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: CupertinoColors.systemGrey5,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text(
            "Barcha e'lonlar",
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
          backgroundColor: Colors.white.withOpacity(.8),
        ),
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
                        "Active",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        "Waiting",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        "Rejected",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        "Deleted",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
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
                    controller: TextEditingController(),
                    focus: FocusNode(),
                  ),
                  AdminHireScreen(
                    statusAnnoun: StatusAnnoun.waiting,
                    context: context,
                    controller: TextEditingController(),
                    focus: FocusNode(),
                  ),
                  AdminHireScreen(
                    statusAnnoun: StatusAnnoun.returned,
                    context: context,
                    controller: TextEditingController(),
                    focus: FocusNode(),
                  ),
                  AdminHireScreen(
                    statusAnnoun: StatusAnnoun.done,
                    context: context,
                    controller: TextEditingController(),
                    focus: FocusNode(),
                  ),
                  AdminHireScreen(
                    statusAnnoun: StatusAnnoun.deleted,
                    context: context,
                    controller: TextEditingController(),
                    focus: FocusNode(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
