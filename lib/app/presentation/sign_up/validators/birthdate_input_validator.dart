import 'package:formz/formz.dart';

enum BirthDateInputError {
  empty,
  invalidFormat,
  notAdult,
}

class BirthDateInputValidator extends FormzInput<String, BirthDateInputError> {
  const BirthDateInputValidator.pure() : super.pure('');

  const BirthDateInputValidator.dirty([String value = '']) : super.dirty(value);

  @override
  BirthDateInputError? validator(String? value) {
    if (value?.isEmpty == true) {
      return BirthDateInputError.empty;
    }

    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(value!)) {
      return BirthDateInputError.invalidFormat;
    }

    final parts = value.split('-');
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);

    if (year == null || month == null || day == null) {
      return BirthDateInputError.invalidFormat;
    }

    final currentDate = DateTime.now();
    final birthDate = DateTime(year, month, day);
    final adultDate = currentDate
        .subtract(const Duration(days: 18 * 365)); // Consideramos 18 años completos.

    if (birthDate.isAfter(adultDate)) {
      return BirthDateInputError.notAdult;
    }

    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    switch (displayError) {
      case BirthDateInputError.empty:
        return 'La fecha de nacimiento es obligatoria';
      case BirthDateInputError.invalidFormat:
        return 'Formato de fecha no válido (aaaa-mm-dd)';
      /*case BirthDateInputError.notAdult:
        return 'Debes ser mayor de 18 años';*/
      default:
        return null;
    }
  }
}
