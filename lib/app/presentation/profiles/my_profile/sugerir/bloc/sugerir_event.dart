part of 'sugerir_bloc.dart';

abstract class SugerirBlocEvent extends Equatable {
  const SugerirBlocEvent();
}

final class EmailChanged extends SugerirBlocEvent {
  const EmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

final class PasswordChanged extends SugerirBlocEvent {
  const PasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

final class ClearData extends SugerirBlocEvent {
  const ClearData();

  @override
  List<Object?> get props => [];
}

final class SignInSubmitted extends SugerirBlocEvent {
  const SignInSubmitted();

  @override
  List<Object?> get props => [];
}
