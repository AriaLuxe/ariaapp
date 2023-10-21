import 'dart:convert';
import 'dart:io';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:http/http.dart' as http;

import '../config/base_url_config.dart';
import '../domain/entities/user_aria.dart';

class SignInService {
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final body = {
        "email": email,
        "password": password,
      };

      final response = await http.post(
        Uri.parse('${BaseUrlConfig.baseUrl}/api/auth/login'),
        body: jsonEncode(body),
        headers: headers,
      );
print(response.body);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody;
      } else if (response.statusCode == 401) {
        final responseBody = jsonDecode(response.body);
        return responseBody;
      } else {

        throw HttpException('Código de estado inesperado: ${response.statusCode}');
      }
    } catch (error) {
      throw HttpException('Error de red: $error');
    }
  }
}
