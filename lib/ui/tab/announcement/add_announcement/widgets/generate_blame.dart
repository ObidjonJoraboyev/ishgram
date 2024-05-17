import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../../blocs/image/image_state.dart';
import '../../../../../utils/utility_functions.dart';

class GenerateBlame extends StatelessWidget {
  const GenerateBlame({super.key, required this.state});

  final ImageUploadState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          (5 - state.images.length),
          (index) => ZoomTapAnimation(
            onTap: () async {
              takeAnImage(
                context,
                limit: 5 - state.images.length,
                images: state.images,
              );
            },
            child: Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  decoration: const BoxDecoration(
                    color: CupertinoColors.systemGrey2,
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 0, blurRadius: 10, color: Colors.black)
                    ],
                  ),
                  width: 150.w,
                  child:
                      (state.formStatus == FormStatus.uploading) && (index == 0)
                          ? Shimmer.fromColors(
                              baseColor: CupertinoColors.systemGrey2,
                              highlightColor: CupertinoColors.systemGrey,
                              child: Container(
                                height: 150.h,
                                width: 150.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                "add_image".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  shadows: [
                                    BoxShadow(
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(.6),
                                    )
                                  ],
                                ),
                              ),
                            ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
