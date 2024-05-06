import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ish_top/utils/constants/app_constants.dart';
import 'package:ish_top/utils/size/size_utils.dart';

import '../../../utils/colors/app_colors.dart';

class PasswordTextInput extends StatefulWidget {
  const PasswordTextInput(
      {super.key, required this.controller, required this.onChanged});

  final TextEditingController controller;

  final ValueChanged onChanged;
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
        onChanged: widget.onChanged,
        style: TextStyle(
          color: AppColors.black,
          fontSize: 13.w,
          fontWeight: FontWeight.w400,
        ),
        controller: widget.controller,
        obscureText: passwordVisibility,
        validator: (String? value) {
          if (value == null ||
              value.isEmpty ||
              value.length < 3 ||
              !AppConstants.passwordRegExp.hasMatch(value)) {
            return "error_password".tr();
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              Icons.lock,
              color: Colors.black.withOpacity(.7),
            ),
          ),
          contentPadding: const EdgeInsets.all(16),
          hintText: "password".tr(),
          suffixIcon: IconButton(
            onPressed: () {
              passwordVisibility = !passwordVisibility;
              setState(() {});
            },
            icon: passwordVisibility
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
          ),
          labelStyle: TextStyle(
            color: AppColors.white.withOpacity(.8),
            fontSize: 13.w,
            fontWeight: FontWeight.w400,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.transparent),
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.transparent),
            borderRadius: BorderRadius.circular(16),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.transparent),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.transparent),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.transparent),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }
}
