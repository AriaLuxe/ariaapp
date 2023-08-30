class UserAria {
  final int id;
  final String nameUser;
  final String lastName;
  final String email;
  final String password;
  final String imgProfile;
  final DateTime? dateBirth;
  final String gender;
  final String country;
  final String city;
  final String registerDate;
  final bool enabled;
  final String? nickname;

  UserAria(
      {required this.id,
      required this.nameUser,
      required this.lastName,
      required this.email,
      required this.password,
      required this.imgProfile,
      this.dateBirth,
      required this.gender,
      required this.country,
      required this.city,
      required this.enabled,
      required this.registerDate,
      this.nickname});
}
