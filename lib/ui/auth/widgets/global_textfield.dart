import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/colors/app_colors.dart';

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
    return TextFormField(
      onChanged: onTap,
      inputFormatters:
          isNumber == true ? [FilteringTextInputFormatter.digitsOnly] : null,
      style: TextStyle(
        color: AppColors.black,
        fontSize: 13.w,
        fontWeight: FontWeight.w400,
      ),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: isNumber == null
            ? Padding(padding: const EdgeInsets.all(12.0), child: iconPath)
            : Padding(
                padding: const EdgeInsets.only(
                    left: 14, top: 14, bottom: 14, right: 2),
                child: Text(
                  hintText,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
        contentPadding: const EdgeInsets.all(16),
        hintText: isNumber == null ? hintText : null,
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textInputAction: TextInputAction.next,
    );
  }
}
