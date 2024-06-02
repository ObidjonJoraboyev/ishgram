import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_state.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/ui/auth/register/register_first.dart';
import 'package:ish_top/ui/auth/register/register_second.dart';
import 'package:ish_top/ui/tab/tab/tab_screen.dart';
import 'package:ish_top/utils/size/size_utils.dart';

class RegisterControl extends StatefulWidget {
  const RegisterControl({super.key});

  @override
  State<RegisterControl> createState() => _RegisterControlState();
}

class _RegisterControlState extends State<RegisterControl> {
  final PageController controller = PageController();

  int activeIndex = 0;

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.formStatus == FormStatus.firstAuth) {
            controller.animateToPage(1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut);
          }
          if (state.formStatus == FormStatus.authenticated) {
            if (!context.mounted) return;
            Navigator.pushAndRemoveUntil(
                context1,
                MaterialPageRoute(builder: (context) => const TabScreen()),
                (route) => false);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              60.getH(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Row(
                  children: [
                    Container(
                      width: (MediaQuery.sizeOf(context).width - 32.w) / 2,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: activeIndex == 0
                            ? CupertinoColors.activeBlue
                            : CupertinoColors.systemGrey,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(120),
                            topRight: Radius.circular(120)),
                      ),
                    ),
                    4.getW(),
                    Container(
                      width: (MediaQuery.sizeOf(context).width - 32.w) / 2,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: activeIndex == 1
                            ? CupertinoColors.activeBlue
                            : CupertinoColors.systemGrey,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(120),
                            topRight: Radius.circular(120)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (v) {
                    activeIndex = v;
                    setState(() {});
                  },
                  controller: controller,
                  children: [
                    const RegisterScreen(),
                    RegisterSecond(userModel: state.userModel)
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
