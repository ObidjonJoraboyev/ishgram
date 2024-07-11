import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/blocs/notification/notification_bloc.dart';
import 'package:ish_top/blocs/notification/notification_event.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/ui/admins_panel/tab/admin_tab/tab_screen.dart';
import 'package:ish_top/ui/auth/register/get_number.dart';
import 'package:ish_top/ui/tab/tab/tab_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    String userNumber = StorageRepository.getString(key: "userNumber");

    Future.delayed(const Duration(seconds: 1), () {
      context.read<AuthBloc>().add(GetCurrentUser());
      context
          .read<NotificationBloc>()
          .add(NotificationGetEvent(context: context));
      setState(() {});
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => userNumber.isEmpty
                ? const RegisterScreen()
                : userNumber != "+998 (95) 083-13-44"
                    ? const TabScreen()
                    : const AdminTabScreen(),
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      body: Center(
        child: Lottie.asset("assets/lotties/splash_2.json"),
      ),
    );
  }
}
