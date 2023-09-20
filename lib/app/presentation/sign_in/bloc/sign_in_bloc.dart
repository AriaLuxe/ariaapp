import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import '../validations/sign_in_form_validator/email_input_validator.dart';
import '../validations/sign_in_form_validator/password_input_validator.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(const SignInState()) {
    on<SignInEvent>((event, emit) {});
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
  }

  void _onEmailChanged(
    EmailChanged event,
    Emitter<SignInState> emit,
  ) {
    final email = EmailInputValidator.dirty(event.email);
    emit(
      state.copyWith(
        emailInputValidator: email,
        isValid: Formz.validate(
          [
            state.passwordInputValidator,
            email,
          ],
        ),
      ),
    );
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    final password = PasswordInputValidator.dirty(event.password);
    emit(
      state.copyWith(
        passwordInputValidator: password,
        isValid: Formz.validate(
          [
            password,
            state.emailInputValidator,
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(formStatus: FormzSubmissionStatus.success));
      //login repository validacion
    }
  }
}
