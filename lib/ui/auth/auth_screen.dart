import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/blocs/auth/auth_state.dart';
import 'package:ish_top/blocs/user_bloc.dart';
import 'package:ish_top/blocs/user_event.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/ui/auth/widgets/button.dart';
import 'package:ish_top/ui/auth/widgets/textfielad.dart';
import 'package:ish_top/ui/tab/tab/tab_screen.dart';
import 'package:ish_top/utils/size/size_utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.num});

  final String num;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
        .copyWith(statusBarIconBrightness: Brightness.dark));
    return PopScope(
      canPop: false,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.formStatus == FormStatus.success) {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              context.read<UserBloc>().add(GetCurrentUser());
              return const TabScreen(
                index: 0,
              );
            }), (v) {
              return false;
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
              floatingActionButton: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: LoginButtonItems(
                  title: "login_button".tr(),
                  onTap: () {
                    context.read<AuthBloc>().add(
                          LoginUserEvent(
                            password: passwordController.text,
                            number: widget.num,
                          ),
                        );
                  },
                  isLoading: state.formStatus == FormStatus.loading,
                  active: checkInput(state.statusMessage),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              backgroundColor: CupertinoColors.systemGrey6,
              appBar: AppBar(
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
                                  context
                                      .read<AuthBloc>()
                                      .add(AuthResetEvent());
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
                        style:
                            const TextStyle(color: CupertinoColors.activeBlue),
                      )
                    ],
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Form(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        0.getH(),
                        Text(
                          "🙈",
                          style: TextStyle(fontSize: 80.sp, color: Colors.red),
                        ),
                        Center(
                          child: Text(
                            "password".tr(),
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
                                "enter_login_pass".tr(),
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
                          child: PasswordTextInput(
                              maxLength: 30,
                              whenError: state.statusMessage == "does not match"
                                  ? "error_password".tr()
                                  : null,
                              controller: passwordController,
                              onChanged: (v) {
                                setState(() {});

                                if (state.statusMessage == "does not match") {
                                  context
                                      .read<AuthBloc>()
                                      .add(AuthResetEvent());
                                }
                              },
                              labelText: "password"),
                        ),
                        16.getH(),
                        SizedBox(
                          height: 35.h,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }

  bool checkInput(String statusMessage) {
    return passwordController.text.length >= 6 &&
        statusMessage != "does not match";
  }
}
