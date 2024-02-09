part of 'sugerir_bloc.dart';

class SugerirState extends Equatable {
  final TitleInputValidator emailInputValidator;
  final ContentInputValidator passwordInputValidator;
  final FormzSubmissionStatus formStatus;
  final bool isValid;

  const SugerirState({
    this.formStatus = FormzSubmissionStatus.initial,
    this.emailInputValidator = const TitleInputValidator.pure(),
    this.passwordInputValidator = const ContentInputValidator.pure(),
    this.isValid = false,
  });

  SugerirState copyWith({
    FormzSubmissionStatus? formStatus,
    TitleInputValidator? emailInputValidator,
    ContentInputValidator? passwordInputValidator,
    bool? isValid,
  }) =>
      SugerirState(
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
