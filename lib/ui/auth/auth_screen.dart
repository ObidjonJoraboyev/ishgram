import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/ui/auth/register/register_screen.dart';
import 'package:ish_top/ui/auth/widgets/button.dart';
import 'package:ish_top/ui/auth/widgets/global_textfield.dart';
import 'package:ish_top/utils/size/size_utils.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../data/forms/form_status.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/images/app_images.dart';
import '../tab/tab/tab_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();

  bool check = false;
  late AnimationController animationController;
  late Animation colorAnimation;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    colorAnimation =
        ColorTween(begin: Colors.white, end: Colors.white.withOpacity(.01))
            .animate(animationController)
          ..addListener(() {
            setState(() {});
          });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    emailController.dispose();
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
                      "Hisobga kirish",
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
                      controller: emailController,
                      hintText: "Ism",
                      type: TextInputType.text,
                      regExp: AppConstants.textRegExp,
                      errorTitle: "Ism noto'g'ri kiritilgan",
                      iconPath: const Icon(CupertinoIcons.star_fill),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 44.w),
                    child: UniversalTextInput(
                      onTap: (s) {
                        setState(() {
                          checkInput();
                        });
                      },
                      controller: passwordController,
                      hintText: "Password",
                      type: TextInputType.text,
                      regExp: AppConstants.textRegExp,
                      errorTitle: "Password noto'g'ri kiritilgan",
                      iconPath: const Icon(CupertinoIcons.padlock_solid),
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
                      title:
                          animationController.isAnimating ? "LOGGING" : "LOGIN",
                      onTap: () {
                        animationController.repeat(reverse: true);
                        context.read<AuthBloc>().add(
                              LoginUserEvent(
                                username: emailController.text,
                                password: passwordController.text,
                              ),
                            );
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
                      const Text(
                        "Akkountingiz yo'qmi?",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: 0.7),
                      ),
                      TextButton(
                        onPressed: () async {
                          await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterScreen()));
                        },
                        child: const Text(
                          "Ro'yxatdan o'tish",
                          style: TextStyle(
                              color: CupertinoColors.activeBlue, fontSize: 18),
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
            await StorageRepository.setBool(key: "isLogin", value: true);
            if (!context.mounted) return;
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const TabScreen()));
          } else {
            animationController.stop();
          }
        },
      ),
    );
  }

  bool checkInput() {
    return AppConstants.textRegExp.hasMatch(emailController.text) &&
        AppConstants.passwordRegExp.hasMatch(passwordController.text);
  }
}
