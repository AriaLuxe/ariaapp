import 'dart:async';

import 'package:ariapp/app/presentation/profiles/my_profile/update_password/validators/confirm_password_input_validator.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/update_password/validators/current_password_input_validator.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../validators/password_input_validator.dart';

part 'update_password_event.dart';
part 'update_password_state.dart';

class UpdatePasswordBloc extends Bloc<UpdatePasswordEvent, UpdatePasswordState> {
  UpdatePasswordBloc() : super(const UpdatePasswordState()) {
    on<UpdatePasswordEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<CurrentPasswordChanged>(_onCurrentPasswordChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
  }

  void _onCurrentPasswordChanged(
      CurrentPasswordChanged event,
      Emitter<UpdatePasswordState> emit,
      ) {
    final currentPassword = CurrentPasswordInputValidator.dirty(event.password);
    emit(
      state.copyWith(
        currentPasswordInputValidator: currentPassword,
        isValid: Formz.validate(
          [
            state.passwordInputValidator,
            state.confirmPasswordInputValidator,
            currentPassword,
          ],
        ),
      ),
    );
  }

  void _onPasswordChanged(
      PasswordChanged event,
      Emitter<UpdatePasswordState> emit,
      ) {
    final password = PasswordInputValidator.dirty(event.password);
    emit(
      state.copyWith(
        passwordInputValidator: password,
        isValid: Formz.validate(
          [
            password,
            state.currentPasswordInputValidator,
            state.confirmPasswordInputValidator,
          ],
        ),
      ),
    );
  }

  void _onConfirmPasswordChanged(
      ConfirmPasswordChanged event,
      Emitter<UpdatePasswordState> emit,
      ) {
    final confirmPassword = PasswordInputValidator.dirty(event.password);
    emit(
      state.copyWith(
        passwordInputValidator: confirmPassword,
        isValid: Formz.validate(
          [
            confirmPassword,
            state.passwordInputValidator,
            state.currentPasswordInputValidator
          ],
        ),
      ),
    );
  }
  Future<void> _onSubmitted(
      PasswordSubmitted event,
      Emitter<UpdatePasswordState> emit,
      ) async {
    if (state.isValid) {
      emit(state.copyWith(formStatus: FormzSubmissionStatus.success));
      //login repository validacion
    }
  }
}
