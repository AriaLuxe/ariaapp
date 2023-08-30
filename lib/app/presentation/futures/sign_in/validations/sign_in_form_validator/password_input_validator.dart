import 'package:formz/formz.dart';

enum PasswordInputError {
  length,
  empty,
  invalidEmail,
}

class PasswordInputValidator extends FormzInput<String, PasswordInputError> {
  const PasswordInputValidator.pure() : super.pure('');

  const PasswordInputValidator.dirty(String value) : super.dirty(value);

  @override
  PasswordInputError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return PasswordInputError.empty;
    }
    if (!isEmail(value)) {
      return PasswordInputError.invalidEmail;
    }
    return null;
  }

  bool isEmail(String value) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(value);
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == PasswordInputError.empty) {
      return 'Este campo es requerido';
    }
    if (displayError == PasswordInputError.invalidEmail) {
      return 'Formato de correo invalido';
    }
    return null;
  }
}
