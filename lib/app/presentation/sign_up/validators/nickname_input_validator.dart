import 'package:formz/formz.dart';

enum NicknameInputError {
  empty,
  tooShort,
}

class NicknameInputValidator extends FormzInput<String, NicknameInputError> {
  const NicknameInputValidator.pure() : super.pure('');

  const NicknameInputValidator.dirty([String value = '']) : super.dirty(value);

  @override
  NicknameInputError? validator(String? value) {
    if (value?.isEmpty == true) {
      return NicknameInputError.empty;
    }
    if (value != null && value.length < 3) {
      return NicknameInputError.tooShort;
    }
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == NicknameInputError.empty) {
      return 'Este campo es requerido';
    }
    if (displayError == NicknameInputError.tooShort) {
      return 'El nickname debe tener al menos 3 caracteres';
    }
    return null;
  }
}
