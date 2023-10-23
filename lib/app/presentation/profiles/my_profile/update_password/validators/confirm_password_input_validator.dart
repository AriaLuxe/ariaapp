import 'package:formz/formz.dart';

enum ConfirmPasswordPasswordInputError {
  length,
  empty,
}

class ConfirmPasswordInputValidator extends FormzInput<String, ConfirmPasswordPasswordInputError> {
  const ConfirmPasswordInputValidator.pure() : super.pure('');

  const ConfirmPasswordInputValidator.dirty(String value) : super.dirty(value);

  @override
  ConfirmPasswordPasswordInputError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return ConfirmPasswordPasswordInputError.empty;
    }
    if (value.length < 4) {
      return ConfirmPasswordPasswordInputError.length;
    }
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == ConfirmPasswordPasswordInputError.empty) {
      return 'Este campo es requerido';
    }
    if (displayError == ConfirmPasswordPasswordInputError.length) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }
}
