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
    required DateTime dateBirth,
    required String gender,
    required String country,
    required String city,
    required String registerDate,
    required bool enabled,
    required String nickname,
  }) : super(
          id: id,
          nameUser: nameUser,
          lastName: lastName,
          email: email,
          password: password,
          imgProfile: imgProfile,
          dateBirth: dateBirth,
          gender: gender,
          country: country,
          city: city,
          registerDate: registerDate,
          enabled: enabled,
          nickname: nickname,
        );

  factory UserAriaModel.fromJson(Map<String, dynamic> json) {
    return UserAriaModel(
      id: json['idUser'],
      nameUser: json['nameUser'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      imgProfile: json['imgProfile'],
      dateBirth: json['dateBirth'] != null
          ? DateTime.parse(json['dateBirth'])
          : DateTime.now(),
      gender: json['gender'],
      country: json['country'],
      city: json['city'],
      registerDate: json['registerDate'],
      enabled: json['enabled'],
      nickname: json['nickName'], // Cambiado a 'nickName'
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
      'dateBirth': dateBirth?.toIso8601String(),
      'gender': gender,
      'country': country,
      'city': city,
      'registerDate': registerDate,
      'enabled': enabled,
      'nickname': nickname,
    };
  }

  static List<UserAriaModel> toUserAriaList(String str) {
    final Iterable decoded = jsonDecode(str);
    return List<UserAriaModel>.from(
        decoded.map((x) => UserAriaModel.fromJson(x)));
  }
}
