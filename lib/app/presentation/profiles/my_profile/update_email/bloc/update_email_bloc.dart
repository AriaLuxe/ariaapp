import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../validators/email_input_validator.dart';
import '../validators/password_input_validator.dart';

part 'update_email_event.dart';
part 'update_email_state.dart';

class UpdateEmailBloc extends Bloc<UpdateEmailEvent, UpdateEmailState> {
  UpdateEmailBloc() : super(const UpdateEmailState()) {
    on<UpdateEmailEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
  }

  void _onEmailChanged(
      EmailChanged event,
      Emitter<UpdateEmailState> emit,
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
      Emitter<UpdateEmailState> emit,
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
      Emitter<UpdateEmailState> emit,
      ) async {
    if (state.isValid) {
      emit(state.copyWith(formStatus: FormzSubmissionStatus.success));
      //login repository validacion
    }
  }
}
