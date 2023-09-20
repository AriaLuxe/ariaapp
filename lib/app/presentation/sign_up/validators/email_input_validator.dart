import 'package:formz/formz.dart';

enum EmailInputError {
  length,
  empty,
  invalidEmail,
}

class EmailInputValidator extends FormzInput<String, EmailInputError> {
  const EmailInputValidator.pure() : super.pure('');

  const EmailInputValidator.dirty(String value) : super.dirty(value);

  @override
  EmailInputError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return EmailInputError.empty;
    }
    if (!isEmail(value)) {
      return EmailInputError.invalidEmail;
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
    if (displayError == EmailInputError.empty) {
      return 'Este campo es requerido';
    }
    if (displayError == EmailInputError.invalidEmail) {
      return 'Formato de correo invalido';
    }
    return null;
  }
}
