part of 'update_password_bloc.dart';

abstract class UpdatePasswordEvent extends Equatable {
  const UpdatePasswordEvent();
}
final class CurrentPasswordChanged extends UpdatePasswordEvent {
  const CurrentPasswordChanged(this.password);
  final String password;

  @override
  List<Object?> get props => [password];
}

final class PasswordChanged extends UpdatePasswordEvent {
  const PasswordChanged(this.password);
  final String password;

  @override
  List<Object?> get props => [password];
}

final class ConfirmPasswordChanged extends UpdatePasswordEvent {
  const ConfirmPasswordChanged(this.password);
  final String password;

  @override
  // TODO: implement props
  List<Object?> get props => [password];
}
final class PasswordSubmitted extends UpdatePasswordEvent {
  const PasswordSubmitted();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
