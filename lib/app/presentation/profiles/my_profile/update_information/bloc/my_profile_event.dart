part of 'my_profile_bloc.dart';

abstract class MyProfileEvent extends Equatable {
  const MyProfileEvent();
  @override
  List<Object?> get props => [];
}


class NameChanged extends MyProfileEvent {
  const NameChanged(this.name);
  final String name;

  @override
  List<Object?> get props => [name];
}



class LastNameChanged extends MyProfileEvent {
  const LastNameChanged(this.lastName);
  final String lastName;

  @override
  List<Object?> get props => [lastName];
}


class BirthDateChanged extends MyProfileEvent {
  const BirthDateChanged(this.birthDate);
  final String birthDate;

  @override
  List<Object?> get props => [birthDate];
}

class SignUpSubmitted extends MyProfileEvent {
  const SignUpSubmitted();
}

class BirthDateSubmitted extends MyProfileEvent {
  final String date;
  const BirthDateSubmitted(this.date);
}

class NicknameChanged extends MyProfileEvent {
  const NicknameChanged(this.nickname);
  final String nickname;

  @override
  List<Object?> get props => [nickname];
}

class CountryChanged extends MyProfileEvent {
  const CountryChanged(this.country);
  final String country;

  @override
  List<Object?> get props => [country];
}

class CityChanged extends MyProfileEvent {
  const CityChanged(this.city);
  final String city;

  @override
  List<Object?> get props => [city];
}

class GenderChanged extends MyProfileEvent {
  const GenderChanged(this.gender);
  final String gender;

  @override
  List<Object?> get props => [gender];
}
class CurrentProfile extends MyProfileEvent {
  const CurrentProfile();
}
class CurrentUser extends MyProfileEvent {
  const CurrentUser();
}