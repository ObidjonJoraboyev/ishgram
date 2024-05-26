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
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: Colors.black),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Pinput(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      controller: controller,
      focusNode: focusNode,
      length: 6,
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
      listenForMultipleSmsOnAndroid: true,
      animationCurve: Curves.linear,
      defaultPinTheme: PinTheme(
        height: 48.w,
        width: 48.w,
        textStyle: const TextStyle(
          fontSize: 22,
          color: Color.fromRGBO(30, 60, 87, 1),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: CupertinoColors.activeBlue),
        ),
      ),
      separatorBuilder: (index) => const SizedBox(width: 8),
      validator: (value) {
        if (value!.length == 6 && int.parse(value) != password) {
          controller.clear();
          return 'Pin is incorrect';
        }
        return null;
      },
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      pinAnimationType: PinAnimationType.scale,
      forceErrorState: false,
      onCompleted: (pin) {
        debugPrint('onCompleted: $pin');
      },
      isCursorAnimationEnabled: true,
      onChanged: valueChanged,
      autofocus: true,
      enabled: true,
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 9),
            width: 22,
            height: 1,
            color: CupertinoColors.activeBlue,
          ),
        ],
      ),
      focusedPinTheme: defaultPinTheme.copyWith(
        height: 48.w,
        decoration: defaultPinTheme.decoration!.copyWith(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: CupertinoColors.activeBlue),
        ),
      ),
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.phone,
      submittedPinTheme: defaultPinTheme.copyWith(
        height: 48.w,
        decoration: defaultPinTheme.decoration!.copyWith(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
              color: int.parse(
                          controller.text.isNotEmpty ? controller.text : "0") !=
                      password
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.activeGreen),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyWith(
        height: 48.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.redAccent),
        ),
      ),
    );
  }
}
