import 'package:formz/formz.dart';

enum CountryInputError {
  empty,
}

class CountryInputValidator extends FormzInput<String, CountryInputError> {
  const CountryInputValidator.pure() : super.pure('');

  const CountryInputValidator.dirty([String value = '']) : super.dirty(value);

  @override
  CountryInputError? validator(String? value) {
    if (value?.isEmpty == true) {
      return CountryInputError.empty;
    }

    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == CountryInputError.empty) {
      return 'Seleccione un pais';
    }

    return null;
  }
}
