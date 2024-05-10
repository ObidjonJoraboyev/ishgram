import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/message/message_bloc.dart';
import 'package:ish_top/blocs/message/message_event.dart';
import 'package:ish_top/ui/splash/splash_screen.dart';

import '../blocs/announcement_bloc/hire_bloc.dart';
import '../blocs/announcement_bloc/hire_event.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => MessageBloc()
            ..add(
              const MessageGetEvent(),
            ),
        ),
        BlocProvider(
          create: (context) => AnnouncementBloc()..add(AnnouncementGetEvent()),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
