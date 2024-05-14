import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ish_top/utils/formatters/formatters.dart';

class GlobalTextFiled extends StatelessWidget {
  const GlobalTextFiled({
    super.key,
    required this.controller,
    required this.labelText,
    this.isPhone,
    this.maxLines,
    this.maxLength,
  });

  final TextEditingController controller;
  final String labelText;
  final int? maxLength;
  final int? maxLines;
  final bool? isPhone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: TextField(
        inputFormatters:
            isPhone != null ? [AppInputFormatters.phoneFormatter] : [],
        controller: controller,
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
            fontSize: 16,
          ),
          contentPadding: const EdgeInsets.all(12),
          fillColor: Colors.grey.withOpacity(.7),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 0, color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 0, color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
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
