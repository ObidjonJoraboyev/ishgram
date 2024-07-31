import 'package:easy_localization/easy_localization.dart';

class AppConstants {
  static RegExp passwordRegExp = RegExp(r'^.{6,}$');
  static RegExp textRegExp = RegExp("[a-zA-Z]");
  static RegExp phoneRegExp = RegExp(r'(^\d{9}$)');
}

String validateUsername(
  String username,
) {
  if (username.isNotEmpty) {
    if (username.length < 5) {
      return "min_five".tr();
    }
    RegExp validUsername = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{4,30}$');
    if (!validUsername.hasMatch(username)) {
      return "Username must start with a ers, numbers, and underscores";
    } else {}
  }
  return "";
}
