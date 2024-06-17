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
import 'package:ish_top/ui/auth/register/register_control.dart';
import 'package:ish_top/ui/auth/widgets/button.dart';
import 'package:ish_top/ui/auth/widgets/textfielad.dart';
import 'package:ish_top/ui/tab/announ/add_announ/widgets/text_field_widget.dart';
import 'package:ish_top/ui/tab/tab/tab_screen.dart';
import 'package:ish_top/utils/formatters/formatters.dart';
import 'package:ish_top/utils/images/app_images.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:rive/rive.dart';

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

  StateMachineController? stateMachineController;
  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

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
          return Padding(
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.w),
                      child: GlobalTextFiled(
                        isLogin: true,
                        onChanged: (v) {
                          setState(() {
                            checkInput();
                          });
                        },
                        controller: numberController,
                        labelText: "phone_number",
                        maxLines: 1,
                        formatter: AppInputFormatters.phoneFormatter,
                        isPhone: true,
                        formStatus: state.formStatus,
                      ),
                    ),
                    RiveAnimation.asset(
                      "assets/rives/login_rive.riv",
                      stateMachines: const ["Login machine"],
                      onInit: (adBoard) {
                        stateMachineController =
                            StateMachineController.fromArtboard(
                                adBoard, "Login Machine");

                        if (stateMachineController == null) return;

                        adBoard.addController(stateMachineController!);
                        isChecking =
                            stateMachineController?.findInput("isChecking");
                        numLook = stateMachineController?.findInput("numLook");
                        isHandsUp =
                            stateMachineController?.findInput("isHandsUp");
                        trigSuccess =
                            stateMachineController?.findInput("trigSuccess");
                        trigFail =
                            stateMachineController?.findInput("trigFail");
                      },
                    ),
                    16.getH(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: PasswordTextInput(
                        labelText: "password",
                        onChanged: (v) {
                          setState(() {
                            checkInput();
                          });
                        },
                        controller: passwordController,
                      ),
                    ),
                    SizedBox(
                      height: 35.h,
                    ),
                    Padding(
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
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            letterSpacing: 0,
                          ),
                        ),
                        CupertinoButton(
                          onPressed: () async {
                            await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterControl(),
                              ),
                            );
                          },
                          child: Text(
                            "no_acc_register".tr(),
                            style: TextStyle(
                              color: CupertinoColors.activeBlue,
                              fontSize: 15.sp,
                            ),
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
    return numberController.text.length == 19 &&
        passwordController.text.length == 6;
  }
}
