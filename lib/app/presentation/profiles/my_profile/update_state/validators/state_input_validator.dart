import 'package:formz/formz.dart';

enum StateInputError {
  empty,
}

class StateInputValidator extends FormzInput<String, StateInputError> {
  const StateInputValidator.pure() : super.pure('');

  const StateInputValidator.dirty(String value) : super.dirty(value);

  @override
  StateInputError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return StateInputError.empty;
    }

    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == StateInputError.empty) {
      return 'Este campo es requerido';
    }

    return null;
  }
}
