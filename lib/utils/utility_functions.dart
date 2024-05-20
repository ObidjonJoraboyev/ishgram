import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../blocs/image/image_bloc.dart';
import '../blocs/image/image_event.dart';
import '../data/models/announcement.dart';

Future<void> _getImageFromGallery(BuildContext context,
    {required int limit, required List<ImageModel> images}) async {
  final ImagePicker picker = ImagePicker();

  if (limit != 1) {
    List<XFile>? image = await picker.pickMultiImage(
      limit: limit,
      maxHeight: 1024,
      maxWidth: 1024,
    );
    if (!context.mounted) return;
    Navigator.pop(context);

    context
        .read<ImageBloc>()
        .add(ImageSetEvent(pickedFile: image, images: images));
  } else {
    XFile? image = await picker.pickImage(
      maxHeight: 1024,
      maxWidth: 1024,
      source: ImageSource.gallery,
    );
    if (!context.mounted) return;

    Navigator.pop(context);

    context
        .read<ImageBloc>()
        .add(ImageSetEvent(pickedFile: [image!], images: images));
  }
}

Future<void> _getImageFromCamera(BuildContext context,
    {required List<ImageModel> images}) async {
  final ImagePicker picker = ImagePicker();

  XFile? image = await picker.pickImage(
    source: ImageSource.camera,
    maxHeight: 1024,
    maxWidth: 1024,
  );
  if (!context.mounted) return;
  Navigator.pop(context);

  context
      .read<ImageBloc>()
      .add(ImageSetEvent(pickedFile: [image!], images: images));
}

void takeAnImage(
  BuildContext context, {
  required int limit,
  required List<ImageModel> images,
}) {
  showCupertinoModalPopup(
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
              await _getImageFromCamera(context, images: images);
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
              await _getImageFromGallery(context, images: images, limit: limit);
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
}) {
  int startTime = DateTime.now().millisecondsSinceEpoch;
  int endTime = DateTime.now().millisecondsSinceEpoch;
  int currentPage = 0;

  final PageController controller = PageController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      DateTime initialDateTime = DateTime.now();
      DateTime minimumDate = DateTime.now();
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
                        )),
                  ],
                ),
                20.getH(),
                Expanded(
                  child: PageView(
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
                                initialDateTime:
                                    initialDateTime.isBefore(minimumDate)
                                        ? minimumDate
                                        : initialDateTime,
                                use24hFormat: true,
                                showDayOfWeek: true,
                                itemExtent: 55,
                                minimumDate: minimumDate,
                                onDateTimeChanged: (v) {
                                  onStartChange(v);
                                  startTime = v.millisecondsSinceEpoch;
                                  setState(() {});
                                }),
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
                              initialDateTime:
                                  initialDateTime.isBefore(minimumDate)
                                      ? minimumDate
                                      : initialDateTime,
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
                      )
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
