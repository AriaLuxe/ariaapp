class UserAria {
  final int? id;
  final String nameUser;
  final String lastName;
  final String email;
  final String password;
  final String? imgProfile;
  final DateTime? dateBirth;
  final String gender;
  final String country;
  final String city;
  final String? registerDate;
  final bool? enabled;
  final String nickname;
  final String? role;
  final String? state;

  UserAria(
      {this.id,
      required this.nameUser,
      required this.lastName,
      required this.email,
      required this.password,
      this.imgProfile,
      this.dateBirth,
      required this.gender,
      required this.country,
      required this.city,
      this.enabled,
      this.registerDate,
      required this.nickname,
      this.role,
      this.state});
}
