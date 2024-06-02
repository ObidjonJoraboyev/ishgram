import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/blocs/auth/auth_state.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/data/models/user_model.dart';
import 'package:ish_top/ui/auth/auth_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/ui/auth/register/widgets/pinput_item.dart';
import 'package:ish_top/ui/auth/widgets/button.dart';
import 'package:ish_top/ui/tab/announ/add_announ/widgets/text_field_widget.dart';
import 'package:ish_top/utils/colors/app_colors.dart';
import 'package:ish_top/utils/formatters/formatters.dart';
import 'package:ish_top/utils/images/app_images.dart';
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
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  Random random = Random();
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey1 = GlobalKey<FormState>();

  int password = 0;

  loginTap() async {
    userModel = userModel.copyWith(
      lastName: lastNameController.text,
      password:
          passwordController.text.isNotEmpty ? passwordController.text : "-1",
      phone: phoneController.text,
      name: firstNameController.text,
    );
    context.read<AuthBloc>().add(
          RegisterUserEvent(password: password, userModel: userModel),
        );
    await StorageRepository.setString(
        key: "userNumber", value: "+998${phoneController.text}");
  }

  init() {
    password = 100000 + random.nextInt(999999 - 100000 + 1);
  }

  UserModel userModel = UserModel.initial;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
        .copyWith(statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    20.getH(),
                    Image.asset(
                      AppImages.signUp,
                      height: 180.h,
                      width: 180.w,
                      fit: BoxFit.fill,
                    ),
                    Center(
                      child: Text(
                        "no_acc_register".tr(),
                        style: TextStyle(
                          color: CupertinoColors.black.withOpacity(.7),
                          fontSize: 22.w,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    32.getH(),
                    GlobalTextFiled(
                      onChanged: (v) {
                        setState(() {
                          checkInput();
                        });
                        if (v.length == 19 &&
                            passwordController.text.length == password) {
                          loginTap();
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
                    16.getH(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: PinPutItem(
                          controller: passwordController,
                          focusNode: focusNode,
                          password: password,
                          valueChanged: (v) {
                            checkInput() ? loginTap() : null;
                            checkInput();
                            setState(() {});
                          }),
                    ),
                    5.getH(),
                    TextButton(
                        onPressed: () async {
                          init();
                          setState(() {});

                          //  final Uri uri = Uri.parse("https://t.me/ustalar_vaqtiuzbot");
                          //  if (await canLaunchUrl(uri)) {
                          //    await launchUrl(uri);
                          //  } else {
                          //    throw 'Could not launch ';
                          //  }
                        },
                        child: Text(
                          "Generate password - $password",
                          style: TextStyle(
                              color: CupertinoColors.activeBlue,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp),
                        )),
                    20.getH(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SizedBox(
                        height: 50.h,
                        child: LoginButtonItems(
                          title: "register".tr(),
                          onTap: () async {
                            loginTap();
                          },
                          isLoading: state.formStatus == FormStatus.loading,
                          active: checkInput(),
                        ),
                      ),
                    ),
                    13.getH(),
                    19.getH(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "account_available".tr(),
                          style: TextStyle(
                            color: AppColors.black.withOpacity(.8),
                            letterSpacing: 0.7,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const AuthScreen();
                                },
                              ),
                            );
                          },
                          child: Text(
                            "login_button".tr(),
                            style: const TextStyle(
                                color: CupertinoColors.activeBlue,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, AuthState state) async {
          //     if (state.formStatus == FormStatus.firstAuth) {
          //             if (!context.mounted) return;
          //
          //             Navigator.pushAndRemoveUntil(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => RegisterSecond(userModel: userModel),
          //                 ),
          //                 (v) => false);
          //           }
        },
      ),
    );
  }

  bool checkInput() {
    return passwordController.text.length == 6 &&
        phoneController.text.length == 19;
  }

  @override
  void dispose() {
    passwordController.dispose();
    firstNameController.dispose();
    phoneController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}
