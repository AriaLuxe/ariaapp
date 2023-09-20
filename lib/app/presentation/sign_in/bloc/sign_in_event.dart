part of 'sign_in_bloc.dart';

@immutable
sealed class SignInEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class EmailChanged extends SignInEvent {
  EmailChanged(this.email);
  final String email;

  @override
  List<Object?> get props => [email];
}

final class PasswordChanged extends SignInEvent {
  PasswordChanged(this.password);
  final String password;

  @override
  List<Object?> get props => [password];
}

final class SignInSubmitted extends SignInEvent {
  SignInSubmitted();
}
