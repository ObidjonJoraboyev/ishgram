import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/data/models/announcement.dart';

class CommentScreen extends StatelessWidget {
  const CommentScreen({super.key, required this.announcementModel});

  final AnnouncementModel announcementModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: "salomlar",
          child: Material(
            color: Colors.transparent,
            child: Text(
              "comments".tr(),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp),
            ),
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.sizeOf(context).width, 2),
          child: Container(
            height: 1,
            color: CupertinoColors.systemGrey,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: CupertinoColors.systemGrey5,
      body: const Center(
        child: TextField(),
      ),
    );
  }
}
