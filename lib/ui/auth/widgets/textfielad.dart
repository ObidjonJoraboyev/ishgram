import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/utils/colors/app_colors.dart';

class PasswordTextInput extends StatefulWidget {
  const PasswordTextInput(
      {super.key,
      required this.controller,
      required this.onChanged,
      required this.labelText,
      this.whenError,
      this.maxLength,
      this.focusNode,
      this.newPass});

  final TextEditingController controller;
  final ValueChanged onChanged;
  final String labelText;
  final bool? newPass;
  final String? whenError;
  final int? maxLength;
  final FocusNode? focusNode;

  @override
  State<PasswordTextInput> createState() => _PasswordTextInputState();
}

class _PasswordTextInputState extends State<PasswordTextInput> {
  bool passwordVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        focusNode: widget.focusNode,
        cursorColor: CupertinoColors.activeBlue,
        onChanged: widget.onChanged,
        keyboardType: TextInputType.text,
        style: TextStyle(
          color: AppColors.black,
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
        controller: widget.controller,
        obscureText: passwordVisibility,
        validator: (String? value) {
          if (widget.whenError != null) {
            return widget.whenError;
          }
          return null;
        },
        maxLength: widget.maxLength,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 9.sp),
          helperText: widget.newPass == true ? "new_password".tr() : null,
          helperStyle: TextStyle(fontSize: 10.sp),
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
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          contentPadding: EdgeInsets.all(9.sp),
          labelText: widget.labelText.tr(),
          iconColor: AppColors.black,
          counterText: "",
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: IconButton(
              onPressed: () {
                passwordVisibility = !passwordVisibility;
                setState(() {});
              },
              icon: !passwordVisibility
                  ? Icon(
                      CupertinoIcons.eye_slash_fill,
                      size: 20.sp,
                      color: AppColors.black,
                    )
                  : Icon(
                      CupertinoIcons.eye_fill,
                      size: 20.sp,
                      color: CupertinoColors.black,
                    ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.transparent),
            borderRadius: BorderRadius.circular(16.r),
          ),
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
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.transparent),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
