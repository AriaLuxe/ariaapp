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
          registerDate: registerDate,
          enabled: enabled,
        );

  factory UserAriaModel.fromJson(Map<String, dynamic> json) {
    return UserAriaModel(
      id: json['id'],
      nameUser: json['nameUser'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      imgProfile: json['imgProfile'],
      registerDate: json['registerDate'],
      enabled: json['enabled'],
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
      'registerDate': registerDate,
      'enabled': enabled,
    };
  }

  static List<UserAriaModel> toUserAriaList(String str) {
    return List<UserAriaModel>.from(
        jsonDecode(str).map((x) => UserAriaModel.fromJson(x)));
  }
}
