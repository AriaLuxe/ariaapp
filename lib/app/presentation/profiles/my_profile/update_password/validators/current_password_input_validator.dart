import 'package:formz/formz.dart';

enum CurrentPasswordInputError {
  length,
  empty,
}

class CurrentPasswordInputValidator extends FormzInput<String, CurrentPasswordInputError> {
  const CurrentPasswordInputValidator.pure() : super.pure('');

  const CurrentPasswordInputValidator.dirty(String value) : super.dirty(value);

  @override
  CurrentPasswordInputError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return CurrentPasswordInputError.empty;
    }
    if (value.length < 4) {
      return CurrentPasswordInputError.length;
    }
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == CurrentPasswordInputError.empty) {
      return 'Este campo es requerido';
    }
    if (displayError == CurrentPasswordInputError.length) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }
}
