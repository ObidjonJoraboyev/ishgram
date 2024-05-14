import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ish_top/ui/auth/register/register_screen.dart';
import 'package:ish_top/ui/auth/widgets/button.dart';
import 'package:ish_top/ui/auth/widgets/global_textfield.dart';
import 'package:ish_top/ui/auth/widgets/textfielad.dart';
import 'package:ish_top/utils/size/size_utils.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../data/forms/form_status.dart';
import '../../data/local/local_storage.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/images/app_images.dart';
import '../tab/tab/tab_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool check = false;

  @override
  void dispose() {
    numberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: CupertinoColors.systemGrey6,
            statusBarIconBrightness: Brightness.dark),
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          return Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  60.getH(),
                  const SizedBox(
                    height: 5,
                  ),
                  SvgPicture.asset(
                    AppImages.login,
                    height: 180.h,
                    width: 180.w,
                    fit: BoxFit.fill,
                  ),
                  Center(
                    child: Text(
                      "login".tr(),
                      style: TextStyle(
                        color: CupertinoColors.black.withOpacity(.6),
                        fontSize: 22.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 44.w),
                    child: UniversalTextInput(
                      onTap: (s) {
                        setState(() {
                          checkInput();
                        });
                      },
                      controller: numberController,
                      hintText: "phone_number".tr(),
                      type: TextInputType.text,
                      regExp: AppConstants.phoneRegExp,
                      errorTitle: "error_phone".tr(),
                      iconPath: const Icon(CupertinoIcons.star_fill),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 44.w),
                    child: PasswordTextInput(
                      onChanged: (v) {
                        setState(() {
                          checkInput();
                        });
                      },
                      controller: passwordController,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 44.w),
                    child: LoginButtonItems(
                      title: "login_button".tr(),
                      onTap: () {
                        context.read<AuthBloc>().add(
                              LoginUserEvent(
                                password: passwordController.text,
                                number: numberController.text.trim(),
                              ),
                            );
                        StorageRepository.setString(
                            key: "userNumber", value: "+998${numberController.text}");
                      },
                      isLoading: state.formStatus == FormStatus.loading,
                      active: checkInput(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "no_account".tr(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: 0),
                      ),
                      TextButton(
                        onPressed: () async {
                          await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterScreen()));
                        },
                        child: Text(
                          "no_acc_register".tr(),
                          style: const TextStyle(
                              color: CupertinoColors.activeBlue, fontSize: 17),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
        listener: (BuildContext context, AuthState state) async {
          if (state.formStatus == FormStatus.authenticated) {
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
    return AppConstants.phoneRegExp.hasMatch(numberController.text) &&
        AppConstants.passwordRegExp.hasMatch(passwordController.text);
  }
}
