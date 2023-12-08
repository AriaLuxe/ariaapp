part of 'update_password_bloc.dart';

class UpdatePasswordState extends Equatable {
  final CurrentPasswordInputValidator currentPasswordInputValidator;
  final ConfirmPasswordInputValidator confirmPasswordInputValidator;

  final PasswordInputValidator passwordInputValidator;
  final FormzSubmissionStatus formStatus;
  final bool isValid;

  const UpdatePasswordState({
    this.formStatus = FormzSubmissionStatus.initial,
    this.currentPasswordInputValidator =
        const CurrentPasswordInputValidator.pure(),
    this.passwordInputValidator = const PasswordInputValidator.pure(),
    this.confirmPasswordInputValidator =
        const ConfirmPasswordInputValidator.pure(),
    this.isValid = false,
  });

  UpdatePasswordState copyWith({
    FormzSubmissionStatus? formStatus,
    CurrentPasswordInputValidator? currentPasswordInputValidator,
    PasswordInputValidator? passwordInputValidator,
    ConfirmPasswordInputValidator? confirmPasswordInputValidator,
    bool? isValid,
  }) =>
      UpdatePasswordState(
        formStatus: formStatus ?? this.formStatus,
        currentPasswordInputValidator:
            currentPasswordInputValidator ?? this.currentPasswordInputValidator,
        passwordInputValidator:
            passwordInputValidator ?? this.passwordInputValidator,
        confirmPasswordInputValidator:
            confirmPasswordInputValidator ?? this.confirmPasswordInputValidator,
        isValid: isValid ?? this.isValid,
      );

  @override
  List<Object> get props => [
        formStatus,
        currentPasswordInputValidator,
        confirmPasswordInputValidator,
        passwordInputValidator,
        isValid,
      ];
}
