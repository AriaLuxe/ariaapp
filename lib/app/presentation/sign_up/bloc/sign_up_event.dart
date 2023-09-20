part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class NameChanged extends SignUpEvent {
  const NameChanged(this.name);
  final String name;

  @override
  List<Object?> get props => [name];
}

class EmailChanged extends SignUpEvent {
  const EmailChanged(this.email);
  final String email;

  @override
  List<Object?> get props => [email];
}

class LastNameChanged extends SignUpEvent {
  const LastNameChanged(this.lastName);
  final String lastName;

  @override
  List<Object?> get props => [lastName];
}

class PasswordChanged extends SignUpEvent {
  const PasswordChanged(this.password);
  final String password;

  @override
  List<Object?> get props => [password];
}

class BirthDateChanged extends SignUpEvent {
  const BirthDateChanged(this.birthDate);
  final String birthDate;

  @override
  List<Object?> get props => [birthDate];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}

class BirthDateSubmitted extends SignUpEvent {
  final String date;
  const BirthDateSubmitted(this.date);
}

class NicknameChanged extends SignUpEvent {
  const NicknameChanged(this.nickname);
  final String nickname;

  @override
  List<Object?> get props => [nickname];
}

class CountryChanged extends SignUpEvent {
  const CountryChanged(this.country);
  final String country;

  @override
  List<Object?> get props => [country];
}

class CityChanged extends SignUpEvent {
  const CityChanged(this.city);
  final String city;

  @override
  List<Object?> get props => [city];
}

class GenderChanged extends SignUpEvent {
  const GenderChanged(this.gender);
  final String gender;

  @override
  List<Object?> get props => [gender];
}
