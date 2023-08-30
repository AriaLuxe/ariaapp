part of 'sign_in_bloc.dart';

final class SignInState extends Equatable {
  final EmailInputValidator emailInputValidator;
  final PasswordInputValidator passwordInputValidator;
  final FormzSubmissionStatus formStatus;
  final bool isValid;
  const SignInState({
    this.formStatus = FormzSubmissionStatus.initial,
    this.emailInputValidator = const EmailInputValidator.pure(),
    this.passwordInputValidator = const PasswordInputValidator.pure(),
    this.isValid = false,
  });

  SignInState copyWith({
    FormzSubmissionStatus? formStatus,
    EmailInputValidator? emailInputValidator,
    PasswordInputValidator? passwordInputValidator,
    bool? isValid,
  }) =>
      SignInState(
        formStatus: formStatus ?? this.formStatus,
        emailInputValidator: emailInputValidator ?? this.emailInputValidator,
        passwordInputValidator:
            passwordInputValidator ?? this.passwordInputValidator,
        isValid: isValid ?? this.isValid,
      );

  @override
  List<Object> get props => [
        formStatus,
        emailInputValidator,
        passwordInputValidator,
      ];
}
