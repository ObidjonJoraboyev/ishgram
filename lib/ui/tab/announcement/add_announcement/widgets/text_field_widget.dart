import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/utils/formatters/formatters.dart';
import '../../../../../blocs/auth/auth_bloc.dart';
import '../../../../../blocs/auth/auth_state.dart';
import '../../../../../data/forms/form_status.dart';
import '../../../../../utils/colors/app_colors.dart';

class GlobalTextFiled extends StatefulWidget {
  const GlobalTextFiled({
    super.key,
    required this.controller,
    required this.labelText,
    required this.onChanged,
    this.isPhone,
    this.maxLines,
    this.maxLength,
    this.formatter,
    required this.formStatus,
  });

  final TextEditingController controller;
  final String labelText;
  final int? maxLength;
  final int? maxLines;
  final bool? isPhone;
  final TextInputFormatter? formatter;
  final ValueChanged<String> onChanged;

  final FormStatus formStatus;

  @override
  State<GlobalTextFiled> createState() => _GlobalTextFiledState();
}

class _GlobalTextFiledState extends State<GlobalTextFiled> {
  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: widget.formStatus != FormStatus.exist
          ? AutovalidateMode.always
          : AutovalidateMode.always,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: BlocConsumer<AuthBloc, AuthState>(
          builder: (context, state) {
            return TextFormField(
              validator: (v) {
                if (state.formStatus == FormStatus.exist) {
                  return "already_registered".tr();
                }

                if (v!.length < 3) {
                  return "minimum_error".tr();
                }
                return null;
              },
              onChanged: widget.onChanged,
              keyboardType: (widget.formatter ==
                          AppInputFormatters.moneyFormatter) ||
                      (widget.formatter == AppInputFormatters.phoneFormatter)
                  ? TextInputType.phone
                  : TextInputType.text,
              inputFormatters:
                  widget.isPhone != null ? [widget.formatter!] : [],
              controller: widget.controller,
              cursorColor: CupertinoColors.activeBlue,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white.withOpacity(.6)),
                labelText: widget.labelText.tr(),
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
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.transparent),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.transparent),
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
              maxLength: widget.maxLength,
              maxLines: widget.maxLines,
            );
          },
          listener: (c, v) {
            if (v.formStatus == FormStatus.exist) {
              setState(() {});
              setState(() {});
            }
          },
        ),
      ),
    );
  }
}
