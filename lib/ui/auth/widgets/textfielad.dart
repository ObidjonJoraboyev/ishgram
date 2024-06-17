import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/utils/colors/app_colors.dart';

class PasswordTextInput extends StatefulWidget {
  const PasswordTextInput(
      {super.key,
      required this.controller,
      required this.onChanged,
      required this.labelText,
      this.newPass});

  final TextEditingController controller;

  final ValueChanged onChanged;
  final String labelText;
  final bool? newPass;

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
        cursorColor: CupertinoColors.activeBlue,
        onChanged: widget.onChanged,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          color: AppColors.black,
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
        controller: widget.controller,
        obscureText: passwordVisibility,
        validator: (String? value) {
          if (value?.length != 6) {
            return "error_password".tr();
          }
          return null;
        },
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
          fillColor: Colors.grey.withOpacity(.7),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          contentPadding: EdgeInsets.all(9.sp),
          labelText: widget.labelText.tr(),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: IconButton(
              onPressed: () {
                passwordVisibility = !passwordVisibility;
                setState(() {});
              },
              icon: passwordVisibility
                  ? Icon(
                      Icons.visibility_off,
                      size: 20.sp,
                    )
                  : Icon(
                      Icons.visibility,
                      size: 20.sp,
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
        textInputAction: TextInputAction.next,
      ),
    );
  }
}
