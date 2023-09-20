import 'package:formz/formz.dart';

enum LastNameInputError {
  empty,
  tooShort,
}

class LastNameInputValidator extends FormzInput<String, LastNameInputError> {
  const LastNameInputValidator.pure() : super.pure('');

  const LastNameInputValidator.dirty([String value = '']) : super.dirty(value);

  @override
  LastNameInputError? validator(String? value) {
    if (value?.isEmpty == true) {
      return LastNameInputError.empty;
    }
    if (value != null && value.length < 3) {
      return LastNameInputError.tooShort;
    }
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == LastNameInputError.empty) {
      return 'Este campo es requerido';
    }
    if (displayError == LastNameInputError.tooShort) {
      return 'El apellido debe tener al menos 3 caracteres';
    }
    return null;
  }
}
