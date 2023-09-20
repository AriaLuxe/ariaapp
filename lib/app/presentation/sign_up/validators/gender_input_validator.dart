import 'package:formz/formz.dart';

enum GenderInputError {
  empty,
}

class GenderInputValidator extends FormzInput<String, GenderInputError> {
  const GenderInputValidator.pure() : super.pure('');

  const GenderInputValidator.dirty([String value = '']) : super.dirty(value);

  @override
  GenderInputError? validator(String? value) {
    if (value?.isEmpty == true) {
      return GenderInputError.empty;
    }

    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == GenderInputError.empty) {
      return 'Seleccione su genero';
    }

    return null;
  }
}
