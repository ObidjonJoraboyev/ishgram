import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class PinPutItem extends StatelessWidget {
  PinPutItem(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.password,
      required this.valueChanged});

  final TextEditingController controller;
  final FocusNode focusNode;
  final int password;
  final ValueChanged<String> valueChanged;
  final defaultPinTheme = PinTheme(
    width: 48.sp,
    height: 48.sp,
    textStyle: TextStyle(
      fontSize: 22.sp,
      color: Colors.black,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19.r),
      border: Border.all(color: Colors.black),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Pinput(
      autofillHints: const [AutofillHints.oneTimeCode],
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      controller: controller,
      focusNode: focusNode,
      length: 6,
      animationCurve: Curves.linear,
      defaultPinTheme: PinTheme(
        height: 48.sp,
        width: 48.sp,
        textStyle: TextStyle(
          fontSize: 22.sp,
          color: Colors.black,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: CupertinoColors.black),
        ),
      ),
      separatorBuilder: (index) => const SizedBox(width: 8),
      validator: (value) {
        if (value!.length == 6 && int.parse(value) != password) {
          controller.clear();
          return 'error_password'.tr();
        }
        return null;
      },
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      pinAnimationType: PinAnimationType.scale,
      forceErrorState: false,
      isCursorAnimationEnabled: true,
      onChanged: valueChanged,
      autofocus: false,
      enabled: true,
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10.h),
            width: 10.w,
            height: 1.h,
            color: CupertinoColors.black,
          ),
        ],
      ),
      focusedPinTheme: defaultPinTheme.copyWith(
        height: 48.sp,
        width: 48.sp,
        decoration: defaultPinTheme.decoration!.copyWith(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: CupertinoColors.black),
        ),
      ),
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.phone,
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
              color: int.parse(
                          controller.text.isNotEmpty ? controller.text : "0") !=
                      password
                  ? CupertinoColors.black
                  : CupertinoColors.activeGreen),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.redAccent),
        ),
      ),
    );
  }
}
