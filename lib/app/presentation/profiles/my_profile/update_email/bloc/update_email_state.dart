part of 'update_email_bloc.dart';

 class UpdateEmailState extends Equatable {
   final EmailInputValidator emailInputValidator;
   final PasswordInputValidator passwordInputValidator;
   final FormzSubmissionStatus formStatus;
   final bool isValid;
   const UpdateEmailState({
     this.formStatus = FormzSubmissionStatus.initial,
     this.emailInputValidator = const EmailInputValidator.pure(),
     this.passwordInputValidator = const PasswordInputValidator.pure(),
     this.isValid = false,
   });

   UpdateEmailState copyWith({
     FormzSubmissionStatus? formStatus,
     EmailInputValidator? emailInputValidator,
     PasswordInputValidator? passwordInputValidator,
     bool? isValid,
   }) =>
       UpdateEmailState(
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
