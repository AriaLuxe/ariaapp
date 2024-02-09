import 'package:formz/formz.dart';

enum ContentInputError {
  empty,
  tooShort,
}

class ContentInputValidator extends FormzInput<String, ContentInputError> {
  const ContentInputValidator.pure() : super.pure('');

  const ContentInputValidator.dirty([String value = '']) : super.dirty(value);

  @override
  ContentInputError? validator(String? value) {
    if (value?.isEmpty == true) {
      return ContentInputError.empty;
    }
    if (value != null && value.length < 3) {
      return ContentInputError.tooShort;
    }
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == ContentInputError.empty) {
      return 'Este campo es requerido';
    }
    if (displayError == ContentInputError.tooShort) {
      return 'El contenido debe tener al menos 3 caracteres';
    }
    return null;
  }
}
