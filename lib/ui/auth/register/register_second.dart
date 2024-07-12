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
import 'package:ish_top/data/models/user_model.dart';
import 'package:ish_top/ui/auth/widgets/button.dart';
import 'package:ish_top/ui/auth/widgets/global_textfield.dart';
import 'package:ish_top/ui/auth/widgets/textfielad.dart';
import 'package:ish_top/ui/tab/tab/tab_screen.dart';
import 'package:ish_top/utils/constants/app_constants.dart';
import 'package:ish_top/utils/formatters/formatters.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:ish_top/utils/utility_functions.dart';
import 'package:pinput/pinput.dart';

class RegisterSecond extends StatefulWidget {
  const RegisterSecond({
    super.key,
  });

  @override
  State<RegisterSecond> createState() => _RegisterSecondState();
}

bool isChecked = false;

class _RegisterSecondState extends State<RegisterSecond> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool check = true;

  UserModel userModel = UserModel.initial;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
        .copyWith(statusBarIconBrightness: Brightness.dark));

    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              actions: [
                IconButton(onPressed: (){
                }, icon: const Icon(Icons.add))
              ],
              scrolledUnderElevation: 0,
              backgroundColor: CupertinoColors.systemGrey6,
              automaticallyImplyLeading: false,
              leadingWidth: double.infinity,
              leading: CupertinoButton(
                onPressed: () {
                  showDialogCustom(
                      content: "want_cancel",
                      context: context,
                      actionFirst: "cancel",
                      onAction: () {
                        context.read<AuthBloc>().add(AuthResetEvent());
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      isRed: true,
                      actionSecond: "close");
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            backgroundColor: CupertinoColors.systemGrey6,
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              0.getH(),
                              Text(
                                "🔏",
                                style: TextStyle(
                                    fontSize: 85.sp, color: Colors.red),
                              ),
                              Center(
                                child: Text(
                                  "no_acc_register".tr(),
                                  style: TextStyle(
                                    color: CupertinoColors.black,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              10.getH(),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 32.w),
                                child: Text(
                                  "enter_more_info".tr(),
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              32.getH(),
                              UniversalTextInput(
                                onTap: (s) {
                                  setState(() {
                                    checkInput();
                                  });
                                },
                                controller: firstNameController,
                                hintText: "name".tr(),
                                type: TextInputType.text,
                                regExp: AppConstants.textRegExp,
                                errorTitle: "error_name".tr(),
                                iconPath: const Icon(CupertinoIcons.star_fill),
                              ),
                              20.getH(),
                              UniversalTextInput(
                                onTap: (s) {
                                  setState(() {
                                    checkInput();
                                  });
                                },
                                controller: lastNameController,
                                hintText: "last_name".tr(),
                                type: TextInputType.text,
                                regExp: AppConstants.textRegExp,
                                errorTitle: "error_lastname".tr(),
                                iconPath: const Icon(
                                    CupertinoIcons.star_lefthalf_fill),
                              ),
                              20.getH(),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                child: PasswordTextInput(
                                  whenError: PasswordValidator.validatePassword(
                                      passwordController.text),
                                  newPass: false,
                                  labelText: "password",
                                  onChanged: (v) {
                                    setState(() {
                                      checkInput();
                                    });
                                  },
                                  controller: passwordController,
                                ),
                              ),
                              15.getH(),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "as_worker".tr(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp),
                                    ),
                                    const Spacer(),
                                    CupertinoSwitch(
                                        value: check,
                                        onChanged: (b) {
                                          check = b;
                                          setState(() {});
                                        })
                                  ],
                                ),
                              ),
                              20.getH(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: LoginButtonItems(
                    title: "continue".tr(),
                    onTap: () async {
                      userModel = userModel.copyWith(
                          lastName: lastNameController.text,
                          name: firstNameController.text,
                          password: passwordController.text);
                      context
                          .read<AuthBloc>()
                          .add(RegisterUserEvent(userModel: userModel));
                    },
                    isLoading: state.formStatus == FormStatus.loading,
                    active: checkInput(),
                  ),
                ),
                20.getH()
              ],
            ),
          ),
        );
      },
      listener: (BuildContext context, AuthState state) async {
        if (state.statusMessage == "success") {

          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return const TabScreen();
          }), (v) {
            return false;
          });
        }
      },
    );
  }

  bool checkInput() {
    return lastNameController.text.length >= 3 &&
        lastNameController.text.length <= 20 &&
        firstNameController.text.length <= 20 &&
        firstNameController.text.length >= 3 &&
        passwordController.length >= 8;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}
