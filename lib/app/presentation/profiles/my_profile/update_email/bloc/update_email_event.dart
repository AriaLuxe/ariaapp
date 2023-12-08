part of 'update_email_bloc.dart';

abstract class UpdateEmailEvent extends Equatable {
  const UpdateEmailEvent();
}

final class EmailChanged extends UpdateEmailEvent {
  const EmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

final class PasswordChanged extends UpdateEmailEvent {
  const PasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

final class SignInSubmitted extends UpdateEmailEvent {
  const SignInSubmitted();

  @override
  List<Object?> get props => [];
}
