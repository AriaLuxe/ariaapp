import 'package:formz/formz.dart';

enum CityInputError {
  empty,
}

class CityInputValidator extends FormzInput<String, CityInputError> {
  const CityInputValidator.pure() : super.pure('');

  const CityInputValidator.dirty([String value = '']) : super.dirty(value);

  @override
  CityInputError? validator(String? value) {
    if (value?.isEmpty == true) {
      return CityInputError.empty;
    }

    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == CityInputError.empty) {
      return 'Ingrese su ciudad';
    }

    return null;
  }
}
