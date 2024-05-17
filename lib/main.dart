import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ish_top/app/app.dart';
import 'package:ish_top/data/local/local_storage.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
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
      fallbackLocale: const Locale("uz", "UZ"),
      child: const App(),
    ),
  );
}
