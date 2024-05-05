import 'package:flutter/material.dart';
import 'package:ish_top/utils/size/size_utils.dart';

import '../../../utils/colors/app_colors.dart';

class UniversalTextInput extends StatelessWidget {
  const UniversalTextInput(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.type,
      required this.regExp,
      required this.errorTitle,
      required this.iconPath});

  final TextEditingController controller;
  final String hintText;
  final TextInputType type;
  final RegExp regExp;
  final String errorTitle;
  final Widget iconPath;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
          return "Enter true $errorTitle";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
        prefixIcon:
            Padding(padding: const EdgeInsets.all(12.0), child: iconPath),
        contentPadding: const EdgeInsets.all(16),
        hintText: hintText,
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
