import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ish_top/utils/size/size_utils.dart';

import '../../../utils/colors/app_colors.dart';

class LoginButtonItems extends StatelessWidget {
  const LoginButtonItems({
    super.key,
    this.title = "",
    required this.onTap,
    required this.isLoading,
    required this.active,
  });

  final VoidCallback onTap;
  final bool isLoading;
  final bool active;
  final String title;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: 18.h,
          horizontal: 0.w,
        ),
        backgroundColor: active
            ? CupertinoColors.activeBlue
            : AppColors.c_262626.withOpacity(.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: active ? onTap : null,
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator.adaptive()
            : Text(
                title.isEmpty ? "REGISTER" : title,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16.w,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
