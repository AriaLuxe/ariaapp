import 'package:formz/formz.dart';

enum PasswordInputError {
  length,
  empty,
}

class PasswordInputValidator extends FormzInput<String, PasswordInputError> {
  const PasswordInputValidator.pure() : super.pure('');

  const PasswordInputValidator.dirty(String value) : super.dirty(value);

  @override
  PasswordInputError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return PasswordInputError.empty;
    }
    if (value.length < 6) {
      return PasswordInputError.length;
    }
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == PasswordInputError.empty) {
      return 'Este campo es requerido';
    }
    if (displayError == PasswordInputError.length) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }
}
