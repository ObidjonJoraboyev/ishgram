import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalaryTextField extends StatelessWidget {
  const SalaryTextField(
      {super.key, required this.controller, required this.valueChanged});

  final TextEditingController controller;
  final ValueChanged valueChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
      child: TextField(
        textInputAction: TextInputAction.done,
        maxLength: 15,
        onChanged: valueChanged,
        keyboardType: TextInputType.phone,
        controller: controller,
        inputFormatters: [
          CurrencyInputFormatter(
            mantissaLength: 0,
            maxTextLength: 1,
            useSymbolPadding: false,
            trailingSymbol: " so'm",
            thousandSeparator: ThousandSeparator.Space,
          )
        ],
        decoration: InputDecoration(
          counterText: "",
          hintStyle: TextStyle(color: Colors.white.withOpacity(.6)),
          labelText: "salary".tr(),
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
          contentPadding: EdgeInsets.all(10.sp),
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 0, color: Colors.white),
            borderRadius: BorderRadius.circular(16.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 0, color: Colors.white),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          shadows: [
            Shadow(color: Colors.white.withOpacity(.4), blurRadius: 10)
          ],
        ),
      ),
    );
  }
}
