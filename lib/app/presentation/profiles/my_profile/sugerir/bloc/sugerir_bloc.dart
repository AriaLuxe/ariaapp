import 'package:ariapp/app/presentation/profiles/my_profile/sugerir/validators/content_input_validator.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/sugerir/validators/title_input_validator.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'sugerir_event.dart';

part 'sugerir_state.dart';

class SugerirBloc extends Bloc<SugerirBlocEvent, SugerirState> {
  SugerirBloc() : super(const SugerirState()) {
    on<SugerirBlocEvent>((event, emit) {});

    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ClearData>(_onClearData);
  }

  void _onEmailChanged(
    EmailChanged event,
    Emitter<SugerirState> emit,
  ) {
    final email = TitleInputValidator.dirty(event.email);
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
    Emitter<SugerirState> emit,
  ) {
    final password = ContentInputValidator.dirty(event.password);
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

  void _onClearData(
    ClearData event,
    Emitter<SugerirState> emit,
  ) {
    emit(
      state.copyWith(
        emailInputValidator: const TitleInputValidator.pure(),
        passwordInputValidator: const ContentInputValidator.pure(),
        isValid: false,
      ),
    );
  }
}
