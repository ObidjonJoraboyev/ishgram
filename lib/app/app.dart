import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/announ_bloc/announ_bloc.dart';
import 'package:ish_top/blocs/announ_bloc/announ_event.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/blocs/connectivity/connectivity_bloc.dart';
import 'package:ish_top/blocs/connectivity/connectivity_event.dart';
import 'package:ish_top/blocs/image/image_bloc.dart';
import 'package:ish_top/blocs/map/map_bloc.dart';
import 'package:ish_top/blocs/map/map_event.dart';
import 'package:ish_top/blocs/message/message_bloc.dart';
import 'package:ish_top/blocs/message/message_event.dart';
import 'package:ish_top/blocs/notification/notification_bloc.dart';
import 'package:ish_top/blocs/notification/notification_event.dart';
import 'package:ish_top/blocs/user_image/user_image_bloc.dart';
import 'package:ish_top/ui/splash/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(GetCurrentUser()),
        ),
        BlocProvider(
          create: (context) => MessageBloc()
            ..add(
              const MessageGetEvent(),
            ),
        ),
        BlocProvider(
          create: (context) => AnnounBloc()..add(AnnounGetEvent()),
        ),
        BlocProvider(
          create: (context) => ImageBloc(),
        ),BlocProvider(
          create: (context) => NotificationBloc()..add(NotificationGetEvent(context: context)),
        ),
        BlocProvider(
          create: (context) => UserImageBloc(),
        ),
        BlocProvider(
          create: (context) => MapBloc()..add(GetUserLocation()),
        ),
        BlocProvider(
          create: (_) => ConnectBloc()..add(CheckConnect()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(357, 812),
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
