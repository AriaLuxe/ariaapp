part of 'update_state_bloc.dart';

class UpdateStateState extends Equatable {
  const UpdateStateState({
    this.stateInputValidator = const StateInputValidator.pure(),
    this.formStatus = FormzSubmissionStatus.initial,
    this.isValid = false,
  });

  final StateInputValidator stateInputValidator;
  final FormzSubmissionStatus formStatus;
  final bool isValid;

  UpdateStateState copyWith({
    StateInputValidator? stateInputValidator,
    FormzSubmissionStatus? formStatus,
    bool? isValid,
  }) =>
      UpdateStateState(
          stateInputValidator: stateInputValidator ?? this.stateInputValidator,
          formStatus: formStatus ?? this.formStatus,
          isValid: isValid ?? this.isValid);

  @override
  List<Object?> get props => [stateInputValidator, formStatus, isValid];
}
