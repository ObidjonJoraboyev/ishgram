import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:alarm/alarm.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ish_top/data/models/announ_model.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:ish_top/utils/utility_functions.dart';
import 'package:permission_handler/permission_handler.dart';

class WidgetOfDetail extends StatefulWidget {
  const WidgetOfDetail({super.key, required this.hireModel});

  final AnnounModel hireModel;

  @override
  State<WidgetOfDetail> createState() => _WidgetOfDetailState();
}

class _WidgetOfDetailState extends State<WidgetOfDetail>
    with SingleTickerProviderStateMixin {
  bool isCallOpen = false;
  late AnimationController controller;
  late Animation<double> animation;

  String time = "";

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..forward()
      ..repeat();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    time = "${DateFormat('dd MMM HH:mm').format(
      DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.hireModel.timeInterval.split(":")[0]),
      ),
    )}  -  ${DateFormat('dd MMM HH:mm').format(
      DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.hireModel.timeInterval.split(":")[1]),
      ),
    )}";
    super.initState();
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Event buildEvent({Recurrence? recurrence}) {
    return Event(
      title: widget.hireModel.title,
      description: widget.hireModel.description,
      location: widget.hireModel.location,
      startDate: DateTime.fromMillisecondsSinceEpoch(
          int.parse(widget.hireModel.timeInterval.split(":")[0])),
      endDate: DateTime.fromMillisecondsSinceEpoch(
          int.parse(widget.hireModel.timeInterval.split(":")[1])),
      allDay: false,
      iosParams: const IOSParams(
        reminder: Duration(minutes: 40),
      ),
      androidParams: const AndroidParams(),
      recurrence: recurrence,
    );
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
          child: Material(
            color: Colors.transparent,
            child: Text(
              widget.hireModel.title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
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
              Material(
                color: Colors.transparent,
                child: Text(
                  widget.hireModel.description,
                  style:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
                ),
              ),
              32.getH(),
              Row(
                children: [
                  Text(
                    time,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                        color: Colors.black),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      Add2Calendar.addEvent2Cal(
                        buildEvent(),
                      );
                    },
                    icon: Icon(
                      CupertinoIcons.calendar_badge_plus,
                      color: CupertinoColors.activeOrange,
                      size: 16.sp,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final status = await Permission.scheduleExactAlarm.status;
                      if (status.isDenied) {
                        await Permission.scheduleExactAlarm.request();
                      }
                      if (!context.mounted) return;

                      addAlarm(
                          context1: context,
                          hireModel: widget.hireModel,
                          valueChanged: (v) {
                            setState(() {});
                          });
                      setState(() {});
                    },
                    icon: Icon(
                      Alarm.getAlarm(42) == null
                          ? Icons.alarm_add
                          : Icons.alarm_on_sharp,
                      size: 16.sp,
                      color: Alarm.getAlarm(42) == null
                          ? CupertinoColors.activeOrange
                          : CupertinoColors.destructiveRed,
                    ),
                  )
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
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
              ),
              trailing: Icon(
                isCallOpen ? Icons.expand_less : Icons.expand_more,
                size: 18.sp,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isCallOpen ? 45.h : 0.0,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      icon: Icon(
                        CupertinoIcons.phone_fill,
                        color: Colors.green,
                        size: 18.sp,
                      ),
                      onPressed: () {
                        launchCaller(widget.hireModel.number);
                      }),
                  IconButton(
                      icon: Icon(
                        CupertinoIcons.chat_bubble_2_fill,
                        color: CupertinoColors.activeBlue,
                        size: 19.sp,
                      ),
                      onPressed: () {
                        launchSms(widget.hireModel.number);
                      }),
                  IconButton(
                    icon: Icon(
                      Icons.copy,
                      size: 16.sp,
                    ),
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
              " ${widget.hireModel.viewedUsers.length}",
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
