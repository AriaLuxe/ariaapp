import 'package:formz/formz.dart';

enum NameInputError {
  empty,
  tooShort,
}

class NameInputValidator extends FormzInput<String, NameInputError> {
  const NameInputValidator.pure() : super.pure('');

  const NameInputValidator.dirty([String value = '']) : super.dirty(value);

  @override
  NameInputError? validator(String? value) {
    if (value?.isEmpty == true) {
      return NameInputError.empty;
    }
    if (value != null && value.length < 3) {
      return NameInputError.tooShort;
    }
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == NameInputError.empty) {
      return 'Este campo es requerido';
    }
    if (displayError == NameInputError.tooShort) {
      return 'El apellido debe tener al menos 3 caracteres';
    }
    return null;
  }
}
