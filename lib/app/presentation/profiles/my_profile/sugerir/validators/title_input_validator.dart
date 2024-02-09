import 'package:formz/formz.dart';

enum TitleInputError {
  empty,
  tooShort,
}

class TitleInputValidator extends FormzInput<String, TitleInputError> {
  const TitleInputValidator.pure() : super.pure('');

  const TitleInputValidator.dirty([String value = '']) : super.dirty(value);

  @override
  TitleInputError? validator(String? value) {
    if (value?.isEmpty == true) {
      return TitleInputError.empty;
    }
    if (value != null && value.length < 3) {
      return TitleInputError.tooShort;
    }
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == TitleInputError.empty) {
      return 'Este campo es requerido';
    }
    if (displayError == TitleInputError.tooShort) {
      return 'El titulo debe tener al menos 3 caracteres';
    }
    return null;
  }
}
