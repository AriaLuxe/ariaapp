import 'dart:convert';

class UserAria {
  final int id;
  final String nameUser;
  final String lastName;
  final String email;
  final String password;
  final String imgProfile;
  final bool enabled;
  final String registerDate;

  UserAria({
    required this.id,
    required this.nameUser,
    required this.lastName,
    required this.email,
    required this.password,
    required this.imgProfile,
    required this.enabled,
    required this.registerDate,
  });

  factory UserAria.fromMap(Map userMap) {
    return UserAria(
      id: userMap['id'],
      nameUser: userMap['nameUser'],
      lastName: userMap['lastName'],
      email: userMap['email'],
      password: userMap['password'],
      imgProfile: userMap['imgProfile'],
      enabled: userMap['enabled'],
      registerDate: userMap['registerDate'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameUser': nameUser,
      'lastName': lastName,
      'email': email,
      'password': password,
      'imgProfile': imgProfile,
      'enabled': enabled,
      'registerDate': registerDate,
    };
  }

  static List<UserAria> toUserAriaList(String str) {
    return List<UserAria>.from(jsonDecode(str).map((x) => UserAria.fromMap(x)));
  }
}
