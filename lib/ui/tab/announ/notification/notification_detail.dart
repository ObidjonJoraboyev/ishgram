import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/data/models/notification_model.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:timeago/timeago.dart';

class NotificationDetailScreen extends StatefulWidget {
  const NotificationDetailScreen({super.key,
  required this.notificationModel});

  final NotificationModel notificationModel;

  @override
  State<NotificationDetailScreen> createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
        backgroundColor: Colors.white.withOpacity(.8),
        title: Text(
          "notification".tr(),
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w,vertical: 18.h),
        child: ListView(
          children: [
            Text(
              widget.notificationModel.title,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),

        10.getH(),
        Text(
          widget.notificationModel.subtitle,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14.sp),
        ),
        15.getH(),
        Text(
          format(
              DateTime.fromMillisecondsSinceEpoch(
                int.parse(widget.notificationModel.dateTime),
              ),
              locale: "uz"),
          style: TextStyle(
              color:
              CupertinoColors.black.withOpacity(.6),
              fontWeight: FontWeight.w500),
        ),
          ],
        ),
      ),
    );
  }
}
