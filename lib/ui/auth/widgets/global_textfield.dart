import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/utils/colors/app_colors.dart';

class UniversalTextInput extends StatelessWidget {
  const UniversalTextInput(
      {super.key,
      this.isNumber,
      required this.controller,
      required this.onTap,
      required this.hintText,
      required this.type,
      required this.regExp,
      required this.errorTitle,
      required this.iconPath});

  final TextEditingController controller;
  final String hintText;
  final ValueChanged onTap;
  final bool? isNumber;
  final TextInputType type;
  final RegExp regExp;
  final String errorTitle;
  final Widget iconPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: TextFormField(
        onChanged: onTap,
        inputFormatters:
            isNumber == true ? [FilteringTextInputFormatter.digitsOnly] : null,
        style: TextStyle(
          color: AppColors.black,
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
        cursorColor: CupertinoColors.activeBlue,
        controller: controller,
        keyboardType: type,
        validator: (String? value) {
          if (value == null ||
              value.isEmpty ||
              value.length < 3 ||
              !regExp.hasMatch(value)) {
            return errorTitle;
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r)),
          filled: true,
          fillColor: CupertinoColors.white,
          labelStyle: TextStyle(
            color: Colors.black.withOpacity(.8),
            fontWeight: FontWeight.w500,
            shadows: [
              BoxShadow(
                  color: Colors.white.withOpacity(.1),
                  blurRadius: 10,
                  spreadRadius: 0)
            ],
            fontSize: 15.sp,
          ),
          contentPadding: EdgeInsets.all(9.sp),
          labelText: isNumber == null ? hintText : null,
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.transparent),
            borderRadius: BorderRadius.circular(16.r),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.transparent),
            borderRadius: BorderRadius.circular(16.r),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.transparent),
            borderRadius: BorderRadius.circular(16.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(16.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }
}
