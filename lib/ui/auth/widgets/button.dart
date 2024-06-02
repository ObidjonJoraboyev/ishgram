import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/utils/colors/app_colors.dart';

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
          vertical: 14.h,
          horizontal: 0.w,
        ),
        backgroundColor: active
            ? CupertinoColors.activeBlue
            : AppColors.c_262626.withOpacity(.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
      ),
      onPressed: active ? onTap : null,
      child: Center(
        child: isLoading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : Text(
                title.isEmpty ? "REGISTER" : title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.w,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
