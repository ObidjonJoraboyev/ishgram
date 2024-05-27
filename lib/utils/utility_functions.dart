import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ish_top/blocs/user_image/user_image_bloc.dart';
import 'package:ish_top/ui/auth/auth_screen.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../blocs/image/image_bloc.dart';
import '../blocs/image/image_event.dart';
import '../blocs/user_image/user_image_event.dart';
import '../data/models/announcement.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> _getImageFromGallery(
  BuildContext context, {
  required int limit,
  required List<ImageModel> images,
  bool? isProfile,
}) async {
  final ImagePicker picker = ImagePicker();

  if (limit != 1) {
    List<XFile>? image = await picker.pickMultiImage(
      limit: limit,
      maxHeight: 1024,
      maxWidth: 1024,
    );
    if (!context.mounted) return;
    Navigator.pop(context);

    isProfile != true
        ? context
            .read<ImageBloc>()
            .add(ImageSetEvent(pickedFile: image, images: images))
        : context
            .read<UserImageBloc>()
            .add(UserImageSetEvent(pickedFile: image));
  } else {
    XFile? image = await picker.pickImage(
      maxHeight: 1024,
      maxWidth: 1024,
      source: ImageSource.gallery,
    );
    if (!context.mounted) return;

    Navigator.pop(context);

    isProfile != true
        ? context
            .read<ImageBloc>()
            .add(ImageSetEvent(pickedFile: [image!], images: images))
        : context.read<UserImageBloc>().add(UserImageSetEvent(
              pickedFile: [image!],
            ));
  }
}

Future<void> _getImageFromCamera(BuildContext context,
    {required List<ImageModel> images, bool? isProfile}) async {
  final ImagePicker picker = ImagePicker();

  XFile? image = await picker.pickImage(
    source: ImageSource.camera,
    maxHeight: 1024,
    maxWidth: 1024,
  );
  if (!context.mounted) return;
  Navigator.pop(context);

  isProfile != true
      ? context
          .read<ImageBloc>()
          .add(ImageSetEvent(pickedFile: [image!], images: images))
      : context.read<UserImageBloc>().add(UserImageSetEvent(
            pickedFile: [image!],
          ));
}

void takeAnImage(
  BuildContext context, {
  required int limit,
  required List<ImageModel> images,
  bool? isProfile,
  ImageModel? imageModel,
}) {
  showCupertinoModalPopup(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
          },
          child: Text(
            "cancel".tr(),
            style: const TextStyle(color: CupertinoColors.activeBlue),
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              await _getImageFromCamera(context,
                  images: images, isProfile: isProfile);
            },
            child: Text(
              "takeCamera".tr(),
              style: const TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontWeight: FontWeight.w500),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              await _getImageFromGallery(context,
                  images: images, limit: limit, isProfile: isProfile);
            },
            child: Text(
              "takeGallery".tr(),
              style: const TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      );
    },
  );
}

show({
  required BuildContext context,
  required VoidCallback cancelButton,
  required VoidCallback doneButton,
  required ValueChanged<DateTime> onStartChange,
  required ValueChanged<DateTime> onEndChange,
  required int startTime,
  required int endTime,
}) {
  int currentPage = 0;

  final PageController controller = PageController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      DateTime minimumDate = DateTime.now();

      DateTime initialStartTime =
          DateTime.fromMillisecondsSinceEpoch(startTime);
      DateTime initialEndTime = DateTime.fromMillisecondsSinceEpoch(endTime);

      if (initialStartTime.isBefore(minimumDate)) {
        initialStartTime = minimumDate;
      }
      if (initialEndTime.isBefore(minimumDate)) {
        initialEndTime = minimumDate;
      }

      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            height: MediaQuery.sizeOf(context).height - 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Column(
              children: [
                20.getH(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ZoomTapAnimation(
                      onTap: cancelButton,
                      child: Text(
                        "cancel".tr(),
                        style: TextStyle(
                            color: CupertinoColors.activeBlue,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    ZoomTapAnimation(
                      onTap: doneButton,
                      child: Text(
                        "done".tr(),
                        style: TextStyle(
                            color: CupertinoColors.activeBlue,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                20.getH(),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (v) {
                      currentPage = v;
                      setState(() {});
                    },
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Column(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              "start_time".tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 200.h,
                            child: CupertinoDatePicker(
                              initialDateTime: initialStartTime,
                              use24hFormat: true,
                              showDayOfWeek: true,
                              itemExtent: 55,
                              minimumDate: minimumDate,
                              onDateTimeChanged: (v) {
                                onStartChange(v);
                                startTime = v.millisecondsSinceEpoch;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              "end_time".tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 200.h,
                            child: CupertinoDatePicker(
                              initialDateTime: initialEndTime,
                              use24hFormat: true,
                              showDayOfWeek: true,
                              itemExtent: 55,
                              minimumDate: minimumDate,
                              onDateTimeChanged: (v) {
                                onEndChange(v);
                                endTime = v.millisecondsSinceEpoch;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                startTime != DateTime.now().millisecondsSinceEpoch
                    ? Center(
                        child: ZoomTapAnimation(
                          onTap: () {
                            controller.animateToPage(currentPage == 0 ? 1 : 0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              currentPage == 1
                                  ? const Icon(
                                      CupertinoIcons.arrow_left,
                                      color: CupertinoColors.activeOrange,
                                    )
                                  : const SizedBox(),
                              10.getW(),
                              Text(
                                currentPage == 0
                                    ? "set_end_time".tr()
                                    : "edit_start".tr(),
                                style: TextStyle(
                                  color: currentPage == 0
                                      ? CupertinoColors.activeBlue
                                      : CupertinoColors.activeOrange,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp,
                                ),
                              ),
                              10.getW(),
                              currentPage == 0
                                  ? const Icon(
                                      CupertinoIcons.arrow_right,
                                      color: CupertinoColors.activeBlue,
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "will_start".tr(),
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      DateFormat('d MMMM HH:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(startTime)),
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                10.getH(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "will_end".tr(),
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      DateFormat('d MMMM HH:mm')
                          .format(DateTime.fromMillisecondsSinceEpoch(endTime)),
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                80.getH(),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<void> launchCaller(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw 'Could not launch $launchUri';
  }
}

Future<void> launchSms(String phoneNumber) async {
  final Uri launchUri = Uri.parse(
      "sms:$phoneNumber${Platform.isIOS ? "&" : "?"}body=${"hi".tr()}");
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $launchUri';
  }
}

Widget toast = Container(
  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    color: Colors.green,
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(
        Icons.check,
        color: Colors.white,
      ),
      const SizedBox(
        width: 12.0,
      ),
      Text(
        "added_hiring".tr(),
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14.sp),
      ),
    ],
  ),
);

addAlarm(
    {required BuildContext context1,
    required AnnouncementModel hireModel,
    required ValueChanged valueChanged}) {
  showCupertinoModalPopup(
    barrierDismissible: false,
    context: context1,
    builder: (context) {
      return StatefulBuilder(
        builder: (context12, setState) {
          var alarm = Alarm.getAlarm(42);
          return CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "cancel".tr(),
                style: TextStyle(
                    color: CupertinoColors.activeBlue,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
            actions: [
              alarm == null
                  ? CupertinoActionSheetAction(
                      onPressed: () async {
                        await Alarm.set(
                          alarmSettings: AlarmSettings(
                            id: 42,
                            dateTime:
                                DateTime.now().add(const Duration(seconds: 5)),
                            assetAudioPath: 'assets/audios/alarm.mp3',
                            loopAudio: false,
                            vibrate: true,
                            volume: 0.2,
                            fadeDuration: 9.0,
                            notificationTitle: 'Ish Vaqti Yaqin ⌛️',
                            notificationBody: hireModel.title,
                            enableNotificationOnKill: true,
                          ),
                        );
                        // Update the alarm state

                        alarm = Alarm.getAlarm(42);
                        valueChanged.call("");
                        if (!context.mounted) return;
                        await Fluttertoast.showToast(
                          msg: "add_note".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        ).then((v) {
                          if (v != null && v) {
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: Text(
                        "Eslatma qo'shish",
                        style: TextStyle(
                            color: CupertinoColors.activeBlue,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp),
                      ),
                    )
                  : const SizedBox(),
              alarm != null
                  ? CupertinoActionSheetAction(
                      onPressed: () async {
                        await Alarm.stop(42);

                        alarm = Alarm.getAlarm(42);
                        valueChanged.call("");

                        if (!context.mounted) return;
                        await Fluttertoast.showToast(
                          msg: "remove_note".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Eslatmani o'chirish",
                        style: TextStyle(
                          color: CupertinoColors.destructiveRed,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          );
        },
      );
    },
  );
}

class UzbekMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';

  @override
  String prefixFromNow() => '';

  @override
  String suffixAgo() => 'oldin';

  @override
  String suffixFromNow() => 'keyin';

  @override
  String lessThanOneMinute(int seconds) => 'Bir necha soniya';

  @override
  String aboutAMinute(int minutes) => 'Bir daqiqa';

  @override
  String minutes(int minutes) => '$minutes daqiqa';

  @override
  String aboutAnHour(int minutes) => 'Taxminan bir soat ';

  @override
  String hours(int hours) => '$hours soat';

  @override
  String aDay(int hours) => 'Bir kun';

  @override
  String days(int days) => '$days kun';

  @override
  String aboutAMonth(int days) => 'Taxminan bir oy';

  @override
  String months(int months) => '$months oy';

  @override
  String aboutAYear(int year) => '$year yil';

  @override
  String years(int years) => '$years yil';

  @override
  String wordSeparator() => ' ';
}

showAskLogin({required BuildContext context, required String title}) {
  showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        content: Text(
          title,
          style: TextStyle(
            color: CupertinoColors.black,
            fontSize: 16.sp,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              "cancel".tr(),
              style: TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
              child: Text(
                "login_button".tr(),
                style: TextStyle(
                    color: CupertinoColors.activeBlue,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return const AuthScreen();
                }), (r) => false);
              })
        ],
      );
    },
  );
}
