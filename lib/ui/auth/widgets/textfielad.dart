import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/colors/app_colors.dart';

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
          color: Colors.white,
          shadows: [
            Shadow(color: Colors.black.withOpacity(.4), blurRadius: 10)
          ],
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
          helperText: widget.newPass == true ? "new_password".tr() : null,
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
          contentPadding: const EdgeInsets.all(16),
          labelText: widget.labelText.tr(),
          suffixIcon: IconButton(
            onPressed: () {
              passwordVisibility = !passwordVisibility;
              setState(() {});
            },
            icon: passwordVisibility
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
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
