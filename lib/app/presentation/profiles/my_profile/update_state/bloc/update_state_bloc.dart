
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../validators/state_input_validator.dart';

part 'update_state_event.dart';
part 'update_state_state.dart';

class UpdateStateBloc extends Bloc<UpdateStateEvent, UpdateStateState> {
  UpdateStateBloc() : super(const UpdateStateState()) {
    on<UpdateStateEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<StateChanged>(_onStateChanged);

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
}
