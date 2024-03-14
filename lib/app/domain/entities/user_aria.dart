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
  final bool? isCreator;
  final String nickname;
  final String? role;
  final String? state;
  final bool? canCreate;
  final bool? enabled;

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
      this.isCreator,
      this.registerDate,
      required this.nickname,
      this.role,
      this.state,
      this.canCreate,
      this.enabled});
}
