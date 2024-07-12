import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/blocs/auth/auth_state.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/ui/admins_panel/tab/announ/widgets/zoom_tap.dart';
import 'package:ish_top/ui/auth/auth_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/ui/auth/register/get_password_screen.dart';
import 'package:ish_top/ui/auth/widgets/button.dart';
import 'package:ish_top/ui/tab/announ/add_announ/widgets/text_field_widget.dart';
import 'package:ish_top/utils/formatters/formatters.dart';
import 'package:ish_top/utils/size/size_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

bool isChecked = false;

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final focusNode = FocusNode();
  int password = 0;

  loginTap() async {
    FocusScope.of(context).unfocus();
    focusNode.unfocus();
    showDialog(
        context: context,
        builder: (context1) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              phoneController.text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24.sp,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                10.getH(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "is_correct_num".tr(),
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: CupertinoColors.black),
                    ),
                  ],
                ),
                10.getH(),
                ScaleOnPress(
                  onTap: () {
                    Navigator.pop(context1);
                    focusNode.requestFocus();
                  },
                  child: Text(
                    "edit".tr(),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                        color: CupertinoColors.activeBlue),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                  child: ScaleOnPress(
                    scaleValue: 0.98,
                    child: LoginButtonItems(
                      onTap: () {
                        Navigator.pop(context1);
                        context1.read<AuthBloc>().add(
                            CheckCurrentUser(userNumber: phoneController.text));
                      },
                      isLoading: false,
                      active: true,
                      title: "Continue",
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    focusNode.requestFocus();
    phoneController.text = "+998";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
        .copyWith(statusBarIconBrightness: Brightness.dark));
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: CupertinoColors.systemGrey6,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                20.getH(),
                                Text(
                                  "📞",
                                  style: TextStyle(
                                      fontSize: 80.sp, color: Colors.red),
                                ),
                                Center(
                                  child: Text(
                                    "Your Phone",
                                    style: TextStyle(
                                      color: CupertinoColors.black,
                                      fontSize: 22.w,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                10.getH(),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 32.w),
                                  child: Text(
                                    "enter_num".tr(),
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                32.getH(),
                                GlobalTextFiled(
                                  focusNode: focusNode,
                                  whenError: null,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (v) {
                                    setState(() {
                                      checkInput();
                                    });
                                    if (v.length == 19) {
                                      setState(() {});
                                    }
                                  },
                                  controller: phoneController,
                                  labelText: "phone_number",
                                  maxLines: 1,
                                  formatter: AppInputFormatters.phoneFormatter,
                                  isPhone: true,
                                  formStatus: state.formStatus,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: LoginButtonItems(
                      title: "Continue",
                      onTap: () async {
                        loginTap();
                      },
                      isLoading: false,
                      active: checkInput(),
                    ),
                  ),
                  20.getH(),

                ],
              ),
              if (state.formStatus == FormStatus.loading)
                Stack(
                  children: [
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 30.sp,
                              height: 30.sp,
                              child: const CircularProgressIndicator(
                                strokeCap: StrokeCap.round,
                                backgroundColor: Colors.grey,
                                color: Colors.white,
                              )),
                          15.getH(),
                          Text("checking".tr(),style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w400,color: Colors.white,shadows: [BoxShadow(spreadRadius: 0,blurRadius: 10,color: Colors.black.withOpacity(.3))]),)
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
      listener: (BuildContext contextListener, AuthState state) async {
        if (state.formStatus == FormStatus.loading) {
          FocusScope.of(contextListener).unfocus();
        }
        if (state.statusMessage.contains("register")) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return GetPasswordScreen(
              num: phoneController.text,
            );
          }));
        } else if (state.statusMessage.contains("already")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const AuthScreen();
              },
            ),
          );
        }
      },
    );
  }

  bool checkInput() {
    return phoneController.text.length == 19;
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
