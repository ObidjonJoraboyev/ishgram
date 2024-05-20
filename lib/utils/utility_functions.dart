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
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      DateTime initialDateTime = DateTime.now();
      DateTime minimumDate = DateTime.now();
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
                      "Done",
                      style: TextStyle(
                          color: CupertinoColors.activeBlue,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    )),
              ],
            ),
            20.getH(),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "Boshlanish vaqti",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
            ),
            SizedBox(
              height: 200.h,
              child: CupertinoDatePicker(
                  initialDateTime: initialDateTime.isBefore(minimumDate)
                      ? minimumDate
                      : initialDateTime,
                  use24hFormat: true,
                  showDayOfWeek: true,
                  itemExtent: 55,
                  minimumDate: minimumDate,
                  onDateTimeChanged: onStartChange),
            ),
            40.getH(),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "Tugash vaqti",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
            ),
            SizedBox(
              height: 200.h,
              child: CupertinoDatePicker(
                  initialDateTime: initialDateTime.isBefore(minimumDate)
                      ? minimumDate
                      : initialDateTime,
                  use24hFormat: true,
                  showDayOfWeek: true,
                  itemExtent: 55,
                  minimumDate: minimumDate,
                  onDateTimeChanged: onEndChange),
            ),
          ],
        ),
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
