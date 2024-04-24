import 'package:ariapp/app/config/base_url_config.dart';
import 'package:http/http.dart' as http;

class EmailValidationDataProvider {
  String endPoint = 'email';

  Future<String> sendEmailToChangedPassword(String email) async {
    try {
      final response = await http.post(
          Uri.parse('${BaseUrlConfig.baseUrl}/$endPoint/token?email=$email'));
      return response.body;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> sendEmailToRegisterUser(String email) async {
    try {
      final response = await http.post(Uri.parse(
          '${BaseUrlConfig.baseUrl}/$endPoint/register-user/token?email=$email'));
      return response.body;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> verifyCodeWithEmailToRegisterUser(
      String email, String code) async {
    try {
      final response = await http.post(Uri.parse(
          '${BaseUrlConfig.baseUrl}/$endPoint/verify/code-register?email=$email&code=$code'));
      return response.body;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> sendEmailToResetPassword(String email) async {
    try {
      final response = await http.post(Uri.parse(
          '${BaseUrlConfig.baseUrl}/$endPoint/password/token?email=$email'));
      return response.body;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> verifyCodeToResetPassword(String email, String code) async {
    try {
      final response = await http.post(Uri.parse(
          '${BaseUrlConfig.baseUrl}/$endPoint/verify/code-password?email=$email&code=$code'));
      return response.body;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> resetPassword(
      String email, String newPassword, String confirmPassword) async {
    try {
      final response = await http.put(Uri.parse(
          '${BaseUrlConfig.baseUrl}/users/reset/password?email=$email&newPassword1=$newPassword&newPassword2=$confirmPassword'));
      return response.body;
    } catch (e) {
      throw Exception(e);
    }
  }
}
