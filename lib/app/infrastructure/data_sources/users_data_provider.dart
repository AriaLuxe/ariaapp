import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/base_url_config.dart';
import '../../domain/entities/user_aria.dart';
import '../../security/shared_preferences_manager.dart';
import '../models/user_aria_model.dart';

class UsersDataProvider {
  String endPoint = 'users';
  Future<List<UserAriaModel>> getUsers() async {

    try {
      String? token = await SharedPreferencesManager.getToken();

      final response =
          await http.get(Uri.parse("${BaseUrlConfig.baseUrl}/$endPoint"),headers: {
          'Authorization': 'Bearer $token',
          },);
      if (response.statusCode == 200) {
        final List<UserAriaModel> users =
            UserAriaModel.toUserAriaList(response.body);
        return users;
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }
  Future<List<UserAriaModel>> searchUsers(String keyword) async {

    try {
      String? token = await SharedPreferencesManager.getToken();

      final response =
      await http.get(Uri.parse("${BaseUrlConfig.baseUrl}/$endPoint/searchUser?keyword=$keyword"),headers: {
        'Authorization': 'Bearer $token',
      },);
      if (response.statusCode == 200) {
        final List<UserAriaModel> users =
        UserAriaModel.toUserAriaList(response.body);
        return users;
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }
  Future<void> signUp(UserAria user) async {
    try {

      final newUser = {
        "nameUser": user.nameUser,
        "lastName": user.lastName,
        "email": user.email,
        "password": user.password,
        "dateBirth": user.dateBirth?.toIso8601String(),
        "gender": user.gender,
        "country": user.country,
        "city": user.city,
        "nickName": user.nickname
      };
      final response = await http.post(
        Uri.parse("${BaseUrlConfig.baseUrl}/$endPoint/add"),
        body: jsonEncode(newUser),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',

        },
      );
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<UserAria> getUserById(int userId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http
          .get(Uri.parse('${BaseUrlConfig.baseUrl}/$endPoint/data/$userId'),headers: {
        'Authorization': 'Bearer $token',
      },);
      if (response.statusCode == 200) {
        final UserAriaModel user =
            UserAriaModel.fromJson(jsonDecode(response.body));
        return user;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
