import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../detail_screen.dart';

class WidgetOfDetail extends StatelessWidget {
  const WidgetOfDetail({super.key, required this.hireModel});

  final AnnouncementModel hireModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        20.getH(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            hireModel.title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
        ),
        10.getH(),
        const Divider(),
        10.getH(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hireModel.description,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),
              15.getH(),
              Row(
                children: [
                  Text(
                    DateFormat('dd MMM HH:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(hireModel.timeInterval.split(":")[0]),
                      ),
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: Colors.black),
                  ),
                  Text(
                    "  -  ${DateFormat('dd MMM HH:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(hireModel.timeInterval.split(":")[1]),
                      ),
                    )}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: Colors.black),
                  ),
                ],
              )
            ],
          ),
        ),
        10.getH(),
        const Divider(),
        10.getH(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ZoomTapAnimation(
            onTap: () async {
              launchCaller(hireModel.number);
            },
            child: Text(
              hireModel.number,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
            ),
          ),
        ),
        10.getH(),
        const Divider(),
        10.getH(),
        Row(
          children: [
            const Icon(
              CupertinoIcons.eye_fill,
              color: CupertinoColors.systemGrey,
            ),
            Text(
              " ${hireModel.countView.length}",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.systemGrey,
              ),
            ),
            Text(
              " ${hireModel.money}",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        )
      ],
    );
  }
}
