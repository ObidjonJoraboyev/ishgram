import 'package:easy_localization/easy_localization.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppInputFormatters {
  static MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
      mask: '+998 (##) ###-##-##',
      filter: {'#': RegExp(r'[+0-9]')},
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
    if (password.length < 6) {
      return 'min_six'.tr();
    }
    if (isCommonPassword(password)) {
      return 'common_password'.tr();
    }
    if (RegExp(r'^(\w)\1*$').hasMatch(password)) {
      return "same_symbol".tr();
    }

    return null;
  }

  static bool isCommonPassword(String password) {
    const List<String> commonPasswords = [
      'password',
      '123456',
      "111111",
      "222222",
      "333333",
      "444444",
      "555555",
      "555555",
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
