import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/blocs/auth/auth_state.dart';
import 'package:ish_top/blocs/user/user_bloc.dart';
import 'package:ish_top/blocs/user/user_event.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/data/local/local_storage.dart';
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
    required this.userNumber,
  });

  final String userNumber;

  @override
  State<RegisterSecond> createState() => _RegisterSecondState();
}

bool isChecked = false;

class _RegisterSecondState extends State<RegisterSecond> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode focusName = FocusNode();
  FocusNode focusLastname = FocusNode();
  FocusNode focusPass = FocusNode();

  int selectedFruit = 0;

  void _showDialog(Widget child) {
    focusName.unfocus();
    focusPass.unfocus();
    focusLastname.unfocus();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: CupertinoColors.white,
        ),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  bool check = true;

  UserModel userModel = UserModel.initial;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
        .copyWith(statusBarIconBrightness: Brightness.dark));

    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
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
                                focusNode: focusName,
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
                                focusNode: focusLastname,
                                onTap: (s) {
                                  setState(() {});
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
                                  focusNode: focusPass,
                                  maxLength: 30,
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
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => _showDialog(
                                    CupertinoPicker(
                                        magnification: 1.22,
                                        squeeze: 1.2,
                                        useMagnifier: true,
                                        itemExtent: 32,
                                        // This sets the initial item.
                                        scrollController:
                                            FixedExtentScrollController(
                                          initialItem: selectedFruit,
                                        ),
                                        // This is called when selected item is changed.
                                        onSelectedItemChanged:
                                            (int selectedItem) {
                                          setState(() {
                                            selectedFruit = selectedItem;
                                          });
                                        },
                                        children: [
                                          const Text("-"),
                                          ...List<Widget>.generate(82,
                                              (int index) {
                                            return Center(
                                                child: Text(
                                                    (index + 18).toString()));
                                          }),
                                        ]),
                                  ),
                                  // This displays the selected fruit name.
                                  child: Row(
                                    children: [
                                      Text(
                                        selectedFruit == 0
                                            ? "enter_your_age".tr()
                                            : "your_age_this".tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: 14.sp),
                                      ),
                                      const Spacer(),
                                      selectedFruit != 0
                                          ? Text(
                                              (selectedFruit + 17).toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0.sp,
                                              ),
                                            )
                                          : Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 14.sp,
                                              color: Colors.black,
                                            )
                                    ],
                                  ),
                                ),
                              ),
                              10.getH(),
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
                              30.getH(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 14.w,
                      right: 14.w,
                      bottom: FocusScope.of(context).hasFocus
                          ? 10.h
                          : MediaQuery.of(context).padding.bottom),
                  child: LoginButtonItems(
                    title: "continue".tr(),
                    onTap: () async {
                      userModel = userModel.copyWith(
                          age: selectedFruit + 17,
                          lastName: lastNameController.text,
                          phone: widget.userNumber,
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
              ],
            ),
          ),
        );
      },
      listener: (BuildContext context, AuthState state) async {
        if (state.statusMessage == "success") {
          StorageRepository.setString(key: "userNum", value: widget.userNumber);
          StorageRepository.setString(key: "userDoc", value: widget.userNumber);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            context.read<UserBloc>().add(GetCurrentUser());
            return const TabScreen();
          }), (v) {
            return false;
          });
        }
      },
    );
  }

  bool checkInput() {
    return lastNameController.text.length <= 30 &&
        firstNameController.text.length <= 30 &&
        firstNameController.text.length >= 3 &&
        passwordController.length >= 6 &&
        selectedFruit != 0;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}
