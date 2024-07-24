import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ish_top/app/app.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/utils/utility_functions.dart';
import 'firebase_options.dart';
import 'package:timeago/timeago.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Alarm.init();
  setLocaleMessages('uz', UzbekMessages());
  await Firebase.initializeApp(
      options: Platform.isIOS ? DefaultFirebaseOptions.currentPlatform : null);
  StorageRepository.instance;
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale("ru", "RU"),
        Locale("uz", "UZ"),
      ],
      path: "assets/translations",
      fallbackLocale: (Platform.localeName.substring(0, 2) == "ru")
          ? const Locale("ru", "RU")
          : const Locale("uz", "UZ"),
      child: const App(),
    ),
  );
}
