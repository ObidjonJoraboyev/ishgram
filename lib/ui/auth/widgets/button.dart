import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/ui/tab/announ/widgets/zoom_tap.dart';

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
    return ScaleOnPress(
      onTap: active ? onTap : null,
      scaleValue: 0.99,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color:
              active ? CupertinoColors.activeBlue : CupertinoColors.systemGrey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? const CupertinoActivityIndicator(color: Colors.white)
                : const SizedBox(),
            Text(
              title.isEmpty ? "REGISTER" : "  $title",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
