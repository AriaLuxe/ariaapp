import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';

import '../validators/state_input_validator.dart';

part 'update_state_event.dart';

part 'update_state_state.dart';

class UpdateStateBloc extends Bloc<UpdateStateEvent, UpdateStateState> {
  final UserAriaRepository userRepository;

  UpdateStateBloc()
      : userRepository = GetIt.instance<UserAriaRepository>(),
        super(const UpdateStateState()) {
    on<UpdateStateEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<StateChanged>(_onStateChanged);
    on<StateCurrent>(_onCurrentState);
  }

  void _onStateChanged(
    StateChanged event,
    Emitter<UpdateStateState> emit,
  ) {
    final stateString = StateInputValidator.dirty(event.state);
    emit(
      state.copyWith(
        stateInputValidator: stateString,
        isValid: Formz.validate(
          [
            stateString,
          ],
        ),
      ),
    );
  }

  void stateChanged(String state) {
    add(StateChanged(state));
  }

  void _onCurrentState(
    StateCurrent event,
    Emitter<UpdateStateState> emit,
  ) async {
    final userUd = await SharedPreferencesManager.getUserId();
    final user = await userRepository.getUserById(userUd!);
    emit(state.copyWith(
      stateInputValidator: StateInputValidator.dirty(user.state ?? ''),
    ));
  }

  void currentState() {
    add(StateCurrent());
  }
}
