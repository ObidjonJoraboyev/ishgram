class AppConstants {
  static RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
  static RegExp passwordRegExp = RegExp(r'^.{6,}$');
  static RegExp textRegExp = RegExp("[a-zA-Z]");
  static RegExp phoneRegExp = RegExp(r'(^^\d{9}$)');
}

String validateUsername(String username) {
  if (username.length < 5) {
    return "Username must be at least 5 characters long";
  }

  if (username.length >= 30) {
    return "Username must be at most 30 characters long";
  }
  RegExp validUsername = RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9_]*$');
  if (!validUsername.hasMatch(username)) {
    return "Username must start with a letter or number and can only contain letters, numbers, and underscores";
  }
  return "";
}
