import 'package:formz/formz.dart';

enum TextMessageError {
  empty,
  tooShort,
}

class TextMessageInputValidator extends FormzInput<String, TextMessageError> {
  const TextMessageInputValidator.pure() : super.pure('');

  const TextMessageInputValidator.dirty([String value = ''])
      : super.dirty(value);

  @override
  TextMessageError? validator(String? value) {
    if (value?.isEmpty == true) {
      return TextMessageError.empty;
    }
    if (value != null && value.length > 2000) {
      return TextMessageError.tooShort;
    }
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == TextMessageError.tooShort) {
      return 'Se permiten máximo 2000 caracteres';
    }
    return null;
  }
}
