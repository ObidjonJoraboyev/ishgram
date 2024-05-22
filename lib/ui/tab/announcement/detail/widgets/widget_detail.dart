import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import '../../../../../utils/utility_functions.dart';

class WidgetOfDetail extends StatefulWidget {
  const WidgetOfDetail({super.key, required this.hireModel});

  final AnnouncementModel hireModel;

  @override
  State<WidgetOfDetail> createState() => _WidgetOfDetailState();
}

class _WidgetOfDetailState extends State<WidgetOfDetail>
    with SingleTickerProviderStateMixin {
  bool isCallOpen = false;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..forward()
      ..repeat();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.getH(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            widget.hireModel.title,
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
                widget.hireModel.description,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),
              15.getH(),
              Row(
                children: [
                  Text(
                    DateFormat('dd MMM HH:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(widget.hireModel.timeInterval.split(":")[0]),
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
                        int.parse(widget.hireModel.timeInterval.split(":")[1]),
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
        SizedBox(
          height: 10.h,
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.grey.withOpacity(.7),
        ),
        Column(children: [
          SizedBox(
            height: 45.h,
            child: ListTile(
              onTap: () {
                setState(() {
                  isCallOpen = !isCallOpen;
                });
              },
              title: Text(
                widget.hireModel.number,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
              ),
              trailing: Icon(
                isCallOpen ? Icons.expand_less : Icons.expand_more,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isCallOpen ? 45.h : 0.0,
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      icon: const Icon(
                        CupertinoIcons.phone_fill,
                        color: Colors.green,
                        size: 30,
                      ),
                      onPressed: () {
                        launchCaller(widget.hireModel.number);
                      }),
                  IconButton(
                      icon: const Icon(
                        CupertinoIcons.chat_bubble_2_fill,
                        color: CupertinoColors.activeBlue,
                        size: 30,
                      ),
                      onPressed: () {
                        launchSms(widget.hireModel.number);
                      }),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () async {
                      await Clipboard.setData(
                          ClipboardData(text: widget.hireModel.number));
                      Fluttertoast.showToast(
                        msg: "copy".tr(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ]),
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.grey.withOpacity(.7),
        ),
        10.getH(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "    ${widget.hireModel.money}",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.black,
              ),
            ),
            const Spacer(),
            const Icon(
              CupertinoIcons.eye_fill,
              color: CupertinoColors.systemGrey,
            ),
            Text(
              " ${widget.hireModel.countView.length}",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.systemGrey,
              ),
            ),
            10.getW()
          ],
        ),
        10.getH(),
      ],
    );
  }
}
