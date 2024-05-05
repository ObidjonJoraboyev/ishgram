import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/ui/auth/register/register_screen.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../data/forms/form_status.dart';
import '../tab/tab/tab_screen.dart';
import '../widgets/auth_text_field.dart';

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
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  UniversalTextField(
                    controller: emailController,
                    hinText: "Email",
                    svgPath: "assets/icons/email.svg",
                    width: 8,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  UniversalTextField(
                    controller: passwordController,
                    hinText: "Password",
                    svgPath: "assets/icons/email.svg",
                    width: 8,
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 90, vertical: 17),
                        backgroundColor: CupertinoColors.activeBlue),
                    onPressed: () async {
                      animationController.repeat(reverse: true);
                      context.read<AuthBloc>().add(
                            LoginUserEvent(
                              username: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                    },
                    child: Text(
                      animationController.isAnimating ? "Logging" : "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: animationController.isAnimating
                            ? colorAnimation.value
                            : Colors.white,
                      ),
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
                      const Text("Akkountingiz yo'qmi?"),
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
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
        listener: (BuildContext context, AuthState state) {
          if (state.formStatus == FormStatus.authenticated) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const TabScreen()));
          } else {
            animationController.stop();
          }
        },
      ),
    );
  }
}
