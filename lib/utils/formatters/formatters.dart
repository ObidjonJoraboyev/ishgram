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
