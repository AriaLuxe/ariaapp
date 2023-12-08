import 'dart:convert';
import '../../domain/entities/follower.dart';

class FollowerModel extends Follower {
  FollowerModel(
      {required int idRequest,
      required int idUser,
      required String nameUser,
      required String lastName,
      required String nickName,
      required String imgProfile,
      required bool follow})
      : super(
            idRequest: idRequest,
            idUser: idUser,
            nameUser: nameUser,
            lastName: lastName,
            nickName: nickName,
            imgProfile: imgProfile,
            follow: follow);

  factory FollowerModel.fromJson(Map<String, dynamic> json) {
    return FollowerModel(
        idRequest: json['idRequest'] ?? 0,
        idUser: json['idUser'] ?? 0,
        nameUser: json['nameUser'] ?? '',
        lastName: json['lastName'] ?? '',
        nickName: json['nickName'] ?? '',
        imgProfile: json['imgProfile'] ?? '',
        follow: json['follow'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'idRequest': idRequest,
      'idUser': idUser,
      'nameUser': nameUser,
      'lastName': lastName,
      'nickName': nickName,
      'imgProfile': imgProfile,
      'follow': follow
    };
  }

  static List<FollowerModel> toFollowerList(String str) {
    final Iterable decoded = jsonDecode(str);
    return List<FollowerModel>.from(
        decoded.map((x) => FollowerModel.fromJson(x)));
  }
}
