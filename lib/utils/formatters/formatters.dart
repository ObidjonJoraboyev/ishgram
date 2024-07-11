import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppInputFormatters {
  static MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
      mask: '+998 (##) ###-##-##',
      filter: {'#': RegExp(r'[\+0-9]')},
      type: MaskAutoCompletionType.lazy);
  static final moneyFormatter = MaskTextInputFormatter(
      mask: "### ### ### ###sum",
      filter: {
        "#": RegExp(r'^\$?(\d{1,3}(,\d{3})*(\.\d{1,2})?|\d+(\.\d{1,2})?)$')
      },
      type: MaskAutoCompletionType.lazy);

  static final cardExpirationDateFormatter = MaskTextInputFormatter(
      mask: '##/##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  static final cardCVCFormatter = MaskTextInputFormatter(
      mask: '###',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
}

class PasswordValidator {
  static String? validatePassword(String password) {
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!containsUppercase(password)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!containsLowercase(password)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!containsDigit(password)) {
      return 'Password must contain at least one digit';
    }

    if (isCommonPassword(password)) {
      return 'Password is too common or easily guessable';
    }

    return null;
  }

  static bool containsUppercase(String password) {
    return RegExp(r'[A-Z]').hasMatch(password);
  }

  static bool containsLowercase(String password) {
    return RegExp(r'[a-z]').hasMatch(password);
  }

  static bool containsDigit(String password) {
    return RegExp(r'[0-9]').hasMatch(password);
  }

  static bool isCommonPassword(String password) {
    // This function should check against a list of common passwords.
    // For simplicity, let's use a small sample list.
    const List<String> commonPasswords = [
      'password',
      '123456',
      '123456789',
      '12345678',
      '12345',
      '1234567',
      '1234567890',
      'qwerty',
      'abc123',
      'password1'
    ];
    return commonPasswords.contains(password);
  }
}
