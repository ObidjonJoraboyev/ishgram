import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/blocs/auth/auth_state.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/ui/auth/register/register_second.dart';
import 'package:ish_top/ui/auth/register/widgets/pinput_item.dart';
import 'package:ish_top/ui/auth/widgets/button.dart';
import 'package:ish_top/utils/size/size_utils.dart';

class GetPasswordScreen extends StatefulWidget {
  const GetPasswordScreen({
    super.key,
    required this.num,
  });

  final String num;

  @override
  State<GetPasswordScreen> createState() => _GetPasswordScreenState();
}

bool isChecked = false;

class _GetPasswordScreenState extends State<GetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController passwordCtrl = TextEditingController();
  final focusNode = FocusNode();
  int password = 111111;

  static const maxSeconds = 120;
  int remainingSeconds = maxSeconds;
  Timer? timer;

  @override
  void initState() {
    startTimer();
    focusNode.requestFocus();
    super.initState();
  }

  void startTimer() {
    remainingSeconds = maxSeconds;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        if (remainingSeconds == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            remainingSeconds--;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
        .copyWith(statusBarIconBrightness: Brightness.dark));
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                remainingSeconds > 0
                    ? Text(
                        "${minutes < 10 ? "0$minutes" : minutes}:${seconds.toString().padLeft(2, '0')}",
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(.7)),
                      )
                    : CupertinoButton(
                        onPressed: remainingSeconds != maxSeconds
                            ? () {
                                startTimer();
                                setState(() {});
                              }
                            : () {},
                        child: Text(
                          "Send again",
                          style: TextStyle(
                              color: CupertinoColors.activeBlue,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp),
                        )),
                remainingSeconds > 0 ? 10.getW() : 0.getW()
              ],
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: CupertinoColors.systemGrey6,
              automaticallyImplyLeading: false,
              leadingWidth: width / 3,
              leading: CupertinoButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("warning".tr()),
                          content: Text("sure_stop".tr()),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text(
                                "cancel".tr(),
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: CupertinoColors.activeBlue),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            CupertinoDialogAction(
                              child: Text(
                                "exit".tr(),
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: CupertinoColors.destructiveRed),
                              ),
                              onPressed: () {
                                context.read<AuthBloc>().add(AuthResetEvent());
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_back_ios_new,
                      color: CupertinoColors.activeBlue,
                    ),
                    Text(
                      "back".tr(),
                      style: const TextStyle(color: CupertinoColors.activeBlue),
                    )
                  ],
                ),
              ),
            ),
            backgroundColor: CupertinoColors.systemGrey6,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: LoginButtonItems(
                title: "Continue",
                onTap: () async {},
                isLoading: state.formStatus == FormStatus.loading,
                active: checkInput(),
              ),
            ),
            body: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        0.getH(),
                        Text(
                          "📨",
                          style: TextStyle(fontSize: 80.sp, color: Colors.red),
                        ),
                        Center(
                          child: Text(
                            "SMS",
                            style: TextStyle(
                              color: CupertinoColors.black,
                              fontSize: 22.w,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        10.getH(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Column(
                            children: [
                              Text(
                                "enter_code".tr(),
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                widget.num,
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        32.getH(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: PinPutItem(
                              controller: passwordCtrl,
                              focusNode: focusNode,
                              password: password,
                              valueChanged: (v) async {
                                if (int.parse(v) == password) {
                                  context
                                      .read<AuthBloc>()
                                      .add(AuthResetEvent());
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return RegisterSecond(
                                          userNumber: widget.num,
                                        );
                                      },
                                    ),
                                  );
                                }
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      listener: (BuildContext contextListener, AuthState state) async {
        //if (state.statusMessage.contains("register")) {
        //           Navigator.push(context, MaterialPageRoute(builder: (context) {
        //             return const RegisterSecond();
        //           }));
        //         } else if (state.statusMessage.contains("already")) {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) {
        //                 return const AuthScreen();
        //               },
        //             ),
        //           );
        //         }
      },
    );
  }

  bool checkInput() {
    return passwordCtrl.text.length == 6;
  }

  @override
  void dispose() {
    passwordCtrl.dispose();
    super.dispose();
  }
}
