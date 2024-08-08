import 'dart:async';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/user/user_bloc.dart';
import 'package:ish_top/blocs/user/user_state.dart';
import 'package:ish_top/utils/constants/app_constants.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:ish_top/utils/utility_functions.dart';

class EditUsernameScreen extends StatefulWidget {
  final ValueChanged voidCallback;
  final String username;

  const EditUsernameScreen({
    super.key,
    required this.voidCallback,
    required this.username,
  });

  @override
  State<EditUsernameScreen> createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends State<EditUsernameScreen> {
  final TextEditingController userName = TextEditingController();
  String errorText = " ";

  @override
  void initState() {
    userName.text = widget.username;
    _onTextChanged(widget.username);
    super.initState();
  }

  Timer? timer;
  bool isLoading = false;
  bool canDone = true;

  void _onTextChanged(String query) {
    canDone = false;
    if (query.isEmpty) {
      canDone = true;
    }
    if (timer?.isActive ?? false) timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), () {
      sendRequest(query);
      setState(() {});
    });
  }

  Future<void> sendRequest(String query) async {
    setState(() {});
    try {
      if (userName.text.isNotEmpty &&
          errorText.isEmpty &&
          userName.text != context.read<UserBloc>().state.userModel.username) {
        isLoading = true;
        Response response = await dio.get(
          "https://ishgram-production.up.railway.app/api/v1/check-username",
          queryParameters: {"username": userName.text},
        );
        if (response.statusCode == 200) {
          setState(() {});
          isLoading = false;
          canDone = true;
        }
      }
      if (userName.text.isNotEmpty) {
        canDone = true;
      }
    } on DioException catch (e) {
      errorText = "invalid_username".tr();
      setState(() {});
      debugPrint('Error: ${e.response?.data}');
      isLoading = false;
      canDone = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            color: CupertinoColors.systemGrey6,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: CupertinoColors.systemGrey6,
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
                            onPressed: errorText.isEmpty &&
                                    isLoading == false &&
                                    canDone
                                ? () {
                                    widget.voidCallback.call(userName.text);
                                    Navigator.pop(context);
                                  }
                                : () {},
                            child: Text(
                              "done".tr(),
                              style: TextStyle(
                                  color: errorText.isEmpty && canDone
                                      ? CupertinoColors.activeBlue
                                      : CupertinoColors.activeBlue
                                          .withOpacity(.6),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    20.getH(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: CupertinoTextField(
                        suffix: isLoading
                            ? Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child:
                                    const CircularProgressIndicator.adaptive(),
                              )
                            : null,
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
                          errorText = validateUsername(v);
                          setState(() {});
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
                    errorText.isNotEmpty && userName.text.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 5.h),
                            child: Text(
                              errorText,
                              style: TextStyle(
                                  color: CupertinoColors.destructiveRed,
                                  fontSize: 12.sp),
                            ),
                          )
                        : userName.text.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24.w, vertical: 5.h),
                                child: Text(
                                  "valid_username".tr(),
                                  style: TextStyle(
                                      color: CupertinoColors.activeGreen,
                                      fontSize: 12.sp),
                                ),
                              )
                            : SizedBox(
                                height: 10.h,
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
            ),
          );
        },
      ),
    );
  }
}
