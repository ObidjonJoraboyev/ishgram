import 'dart:async';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/user_bloc.dart';
import 'package:ish_top/blocs/user_state.dart';
import 'package:ish_top/utils/constants/app_constants.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:ish_top/utils/utility_functions.dart';

class EditUsernameScreen extends StatefulWidget {
  const EditUsernameScreen({super.key});

  @override
  State<EditUsernameScreen> createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends State<EditUsernameScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController userName = TextEditingController();

  String errorText = "";

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  late AnimationController _controller;

  Timer? _debounce;

  void resetAnimation() async {
    _controller.reset();
  }

  void _onTextChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _sendRequest(query);
    });
  }

  Future<void> _sendRequest(String query) async {
    try {
      if (userName.text.isNotEmpty &&
          errorText.isEmpty &&
          userName.text != context.read<UserBloc>().state.userModel.username) {
        Response response = await dio.get(
          "https://ishgram-production.up.railway.app/api/v1/check-username",
          queryParameters: {"username": userName.text},
        );
        if (response.statusCode == 200) {
          errorText = "";
          setState(() {});
        }
      }
    } on DioException catch (e) {
      errorText = "invalid_username".tr();
      errorText = validateUsername(userName.text, errorText: errorText);
      setState(() {});
      debugPrint('Error: ${e.response?.data}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: CupertinoColors.systemGrey5,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Text(
                              "cancel".tr(),
                              style: TextStyle(
                                  color: CupertinoColors.activeBlue,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            onPressed: () {
                              userName.text = state.userModel.username;
                              Navigator.pop(context);
                            }),
                        Text(
                          "username".tr(),
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w600),
                        ),
                        CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Text(
                              "done".tr(),
                              style: TextStyle(
                                  color: CupertinoColors.activeBlue,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                  ),
                  20.getH(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: CupertinoTextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9_]')),
                        UsernameTextInputFormatter()
                      ],
                      maxLength: 30,
                      onTapOutside: (v) {
                        setState(() {});
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (v) async {
                        _onTextChanged(v);
                      },
                      cursorColor: CupertinoColors.activeBlue,
                      placeholder: "username".tr(),
                      padding: EdgeInsets.all(10.sp),
                      controller: userName,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: Colors.white),
                    ),
                  ),
                  errorText.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 5.h),
                          child: Text(
                            errorText,
                            style: const TextStyle(
                                color: CupertinoColors.destructiveRed,
                                fontSize: 12),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 5.h),
                          child: Text(
                            "valid_username".tr(),
                            style: const TextStyle(
                                color: CupertinoColors.activeGreen,
                                fontSize: 12),
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Text(
                      "username_description".tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
