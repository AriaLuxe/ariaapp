import 'dart:convert';

import 'package:ariapp/app/domain/entities/user_aria.dart';

class UserAriaModel extends UserAria {
  UserAriaModel({
    required int id,
    required String nameUser,
    required String lastName,
    required String email,
    required String password,
    required String imgProfile,
    required bool enabled,
    required String registerDate,
  }) : super(
            id: id,
            nameUser: nameUser,
            lastName: lastName,
            email: email,
            password: password,
            imgProfile: imgProfile,
            enabled: enabled,
            registerDate: registerDate);

  factory UserAriaModel.fromMap(Map userMap) {
    return UserAriaModel(
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

  static List<UserAriaModel> toUserAriaList(String str) {
    return List<UserAriaModel>.from(
        jsonDecode(str).map((x) => UserAriaModel.fromMap(x)));
  }
}
