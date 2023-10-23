part of 'update_state_bloc.dart';

abstract class UpdateStateEvent extends Equatable {
  const UpdateStateEvent();
}
final class StateChanged extends UpdateStateEvent {
  const StateChanged(this.state);
  final String state;

  @override
  List<Object?> get props => [state];
}