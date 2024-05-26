import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/blocs/auth/auth_state.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/data/models/user_model.dart';
import 'package:ish_top/ui/auth/auth_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/ui/auth/widgets/button.dart';
import 'package:ish_top/utils/colors/app_colors.dart';
import 'package:ish_top/utils/images/app_images.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import '../../../utils/constants/app_constants.dart';
import '../widgets/global_textfield.dart';
import '../widgets/textfielad.dart';

class RegisterSecond extends StatefulWidget {
  const RegisterSecond({super.key, required this.userModel});

  final UserModel userModel;

  @override
  State<RegisterSecond> createState() => _RegisterSecondState();
}

bool isChecked = false;

class _RegisterSecondState extends State<RegisterSecond> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                    60.getH(),
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
                    26.getH(),
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
                    18.getH(),
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
                      iconPath: const Icon(CupertinoIcons.star_lefthalf_fill),
                    ),
                    18.getH(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: PasswordTextInput(
                        newPass: true,
                        labelText: "password",
                        onChanged: (v) {
                          setState(() {
                            checkInput();
                          });
                        },
                        controller: passwordController,
                      ),
                    ),
                    24.getH(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: LoginButtonItems(
                        title: "register".tr(),
                        onTap: () async {
                          context.read<AuthBloc>().add(
                                RegisterUpdateEvent(
                                  userModel: state.userModel.copyWith(
                                      lastName: lastNameController.text,
                                      name: firstNameController.text,
                                      password: passwordController.text),
                                  docId: state.userModel.docId,
                                ),
                              );
                        },
                        isLoading: state.formStatus == FormStatus.loading,
                        active: checkInput(),
                      ),
                    ),
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
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, AuthState state) async {
          //   if (state.formStatus == FormStatus.authenticated) {
          //             if (!context.mounted) return;
          //             Navigator.pushAndRemoveUntil(
          //                 context,
          //                 MaterialPageRoute(builder: (context) => const TabScreen()),
          //                 (route) => true);
          //           }
        },
      ),
    );
  }

  bool checkInput() {
    return lastNameController.text.length >= 3 &&
        lastNameController.text.length <= 20 &&
        firstNameController.text.length <= 20 &&
        firstNameController.text.length >= 3;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}
