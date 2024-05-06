import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/hire_bloc/hire_bloc.dart';
import 'package:ish_top/blocs/hire_bloc/hire_event.dart';
import 'package:ish_top/blocs/image/image_bloc.dart';
import 'package:ish_top/blocs/user_profile/user_profile_bloc.dart';
import 'package:ish_top/data/repository/auth_repo.dart';
import 'package:ish_top/data/repository/user_profile_repo.dart';
import 'package:ish_top/ui/splash/splash_screen.dart';

import '../blocs/auth/auth_event.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => UserProfileRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>())
                  ..add(CheckAuthenticationEvent()),
          ),
          BlocProvider(
            create: (context) => HireBloc()..add(HireGetEvent()),
          ), BlocProvider(
            create: (context) => ImageBloc(),
          ),
          BlocProvider(
            create: (context) => UserProfileBloc(
                userProfileRepository: context.read<UserProfileRepository>()),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
