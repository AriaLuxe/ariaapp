import 'dart:convert';

import 'package:ariapp/app/security/shared_preferences_manager.dart';

import '../config/base_url_config.dart';
import '../domain/entities/user_aria.dart';
import 'package:http/http.dart' as http;

class SignInService {
  Future<bool> signIn(String email, String password) async {
    try {
      String url = "${BaseUrlConfig.baseUrl}/auth/auth/login";
      final headers = {'Content-Type': 'application/json'};
      final body = {
        "username": email,
        "password": password,
      };
      //  final response = await http.post(Uri.parse(url),
      //  body: jsonEncode(body), headers: headers);

      int idLogged = 1;
      SharedPreferencesManager.saveUserId(idLogged);

      //if (response.statusCode == 200) {
      //var decodedJson = json.decode(response.body);
      //print(decodedJson);

      //return true;
      //} else {
      // return false;
      //}
      return true;
    } catch (error) {
      throw Exception('Failed to fetch offers: $error');
    }
  }
}
