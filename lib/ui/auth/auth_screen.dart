import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/blocs/auth/auth_state.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/ui/admins_panel/tab/admin_tab/tab_screen.dart';
import 'package:ish_top/ui/auth/register/get_number.dart';
import 'package:ish_top/ui/auth/widgets/button.dart';
import 'package:ish_top/ui/tab/announ/add_announ/widgets/text_field_widget.dart';
import 'package:ish_top/ui/tab/tab/tab_screen.dart';
import 'package:ish_top/utils/formatters/formatters.dart';
import 'package:ish_top/utils/images/app_images.dart';
import 'package:ish_top/utils/size/size_utils.dart';

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

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
        .copyWith(statusBarIconBrightness: Brightness.dark));
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        String userNumber = StorageRepository.getString(key: "userNumber");
        if (state.formStatus == FormStatus.authenticated) {
          if (!context.mounted) return;
          if (userNumber != "+998 (95) 083-13-44") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const TabScreen()),
                (route) => false);
          }
          {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AdminTabScreen()),
                (route) => false);
          }
        }
        if (state.formStatus == FormStatus.notExist) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog.adaptive(
                  title: Text("error".tr()),
                  content: Text("account_not_exist".tr()),
                  actions: <Widget>[
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context);

                        passwordController.clear();
                      },
                      child: Text(
                        "cancel".tr(),
                        style: const TextStyle(
                            color: CupertinoColors.activeBlue,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return const RegisterScreen();
                        }), (v) => false);
                      },
                      child: Text(
                        "register".tr(),
                        style: const TextStyle(
                            color: CupertinoColors.activeBlue,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                );
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
                          number: numberController.text.trim(),
                        ),
                      );
                },
                isLoading: state.formStatus == FormStatus.loading,
                active: checkInput(),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            backgroundColor: CupertinoColors.systemGrey6,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      60.getH(),
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
                      32.getH(),
                      GlobalTextFiled(
                        whenError: PasswordValidator.validatePassword(
                            passwordController.text),
                        textInputAction: TextInputAction.done,
                        onChanged: (v) {
                          setState(() {
                            checkInput();
                          });
                          if (v.length == 19 &&
                              passwordController.text.length > 8) {
                            setState(() {});
                          }
                        },
                        controller: passwordController,
                        labelText: "phone_number",
                        maxLines: 1,
                        formatter: AppInputFormatters.moneyFormatter,
                        isPhone: false,
                        isLogin: true,
                        formStatus: state.formStatus,
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
    );
  }

  bool checkInput() {
    return numberController.text.length == 19 &&
        passwordController.text.length == 6;
  }
}
