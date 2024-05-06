import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ish_top/ui/auth/auth_screen.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../blocs/user_profile/user_profile_bloc.dart';
import '../../../blocs/user_profile/user_profile_event.dart';
import '../../../data/forms/form_status.dart';
import '../../../data/models/user_model.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/images/app_images.dart';
import '../../../utils/size/size_utils.dart';
import '../../tab/tab/tab_screen.dart';
import '../widgets/button.dart';
import '../widgets/global_textfield.dart';
import '../widgets/textfielad.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

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
              padding: EdgeInsets.symmetric(horizontal: 44.w),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    60.getH(),
                    SvgPicture.asset(
                      AppImages.signUp,
                      height: 180.h,
                      width: 180.w,
                      fit: BoxFit.fill,
                    ),
                    16.getH(),
                    Center(
                      child: Text(
                        "no_acc_register".tr(),
                        style: TextStyle(
                          color: CupertinoColors.black.withOpacity(.6),
                          fontSize: 22.w,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    16.getH(),
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
                    16.getH(),
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
                    16.getH(),
                    UniversalTextInput(
                      onTap: (s) {
                        setState(() {
                          checkInput();
                        });
                      },
                      controller: phoneController,
                      hintText: "+998",
                      type: TextInputType.number,
                      regExp: AppConstants.phoneRegExp,
                      errorTitle: "error_phone".tr(),
                      iconPath: const Icon(CupertinoIcons.phone),
                      isNumber: true,
                    ),
                    16.getH(),
                    PasswordTextInput(
                      onChanged: (v) {
                        setState(() {
                          checkInput();
                        });
                      },
                      controller: passwordController,
                    ),
                    35.getH(),
                    LoginButtonItems(
                      title: "register".tr(),
                      onTap: () {
                        context.read<AuthBloc>().add(
                              RegisterUserEvent(
                                userModel: UserModel(
                                  image: "",
                                  email:
                                      "${firstNameController.text.toLowerCase()}@gmail.com",
                                  lastName: lastNameController.text,
                                  password: passwordController.text,
                                  number: phoneController.text,
                                  docId: "",
                                  name: firstNameController.text,
                                  fcm: "",
                                  authUid: "",
                                  city: '',
                                  age: 12,
                                ),
                              ),
                            );
                      },
                      isLoading: state.formStatus == FormStatus.loading,
                      active: checkInput(),
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
          if (state.formStatus == FormStatus.authenticated) {
            if (state.statusMessage == "registered") {
              context.read<UserProfileBloc>().add(
                    AddUserEvent(
                      userModel: state.userModel,
                    ),
                  );
            }
            BlocProvider.of<UserProfileBloc>(context).add(
              GetCurrentUserEvent(
                uid: FirebaseAuth.instance.currentUser!.uid,
              ),
            );
            if (!context.mounted) return;
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const TabScreen()),
                (route) => false);
          }
        },
      ),
    );
  }

  bool checkInput() {
    return AppConstants.textRegExp.hasMatch(firstNameController.text) &&
        AppConstants.textRegExp.hasMatch(lastNameController.text) &&
        AppConstants.passwordRegExp.hasMatch(passwordController.text) &&
        AppConstants.phoneRegExp.hasMatch(phoneController.text);
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
