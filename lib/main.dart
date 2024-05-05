import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ish_top/app/app.dart';
import 'package:ish_top/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: Platform.isIOS ? DefaultFirebaseOptions.currentPlatform : null);
  runApp(const App());
}
