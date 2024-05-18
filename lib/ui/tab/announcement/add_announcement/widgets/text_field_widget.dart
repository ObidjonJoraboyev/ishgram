import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/utils/formatters/formatters.dart';

class GlobalTextFiled extends StatelessWidget {
  const GlobalTextFiled({
    super.key,
    required this.controller,
    required this.labelText,
    required this.onChanged,
    this.isPhone,
    this.maxLines,
    this.maxLength,
    this.formatter,
  });

  final TextEditingController controller;
  final String labelText;
  final int? maxLength;
  final int? maxLines;
  final bool? isPhone;
  final TextInputFormatter? formatter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: TextField(
        onChanged: onChanged,
        keyboardType: (formatter == AppInputFormatters.moneyFormatter) ||
                (formatter == AppInputFormatters.phoneFormatter)
            ? TextInputType.phone
            : TextInputType.text,
        inputFormatters: isPhone != null ? [formatter!] : [],
        controller: controller,
        cursorColor: CupertinoColors.activeBlue,
        decoration: InputDecoration(

          hintStyle: TextStyle(color: Colors.white.withOpacity(.6)),
          labelText: labelText.tr(),
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
          contentPadding: EdgeInsets.all(12.sp),
          fillColor: Colors.grey.withOpacity(.7),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 0, color: Colors.grey),
            borderRadius: BorderRadius.circular(16.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 0, color: Colors.grey),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        style: TextStyle(
          color: Colors.white,
          shadows: [
            Shadow(color: Colors.black.withOpacity(.4), blurRadius: 10)
          ],
        ),
        maxLength: maxLength,
        maxLines: maxLines,
      ),
    );
  }
}
