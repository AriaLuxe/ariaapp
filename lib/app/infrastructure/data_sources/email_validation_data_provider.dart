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

  Future<EmailToRegisterUserResponse> sendEmailToRegisterUser(
      String email) async {
    try {
      final response = await http.post(Uri.parse(
          '${BaseUrlConfig.baseUrl}/$endPoint/register-user/token?email=$email'));
      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody == 'Email sent successfully') {
          return EmailToRegisterUserResponse.emailSentSuccessfully;
        } else if (responseBody ==
            'Has already exists an account with this email') {
          return EmailToRegisterUserResponse.accountExists;
        } else if (responseBody == 'Code already send to this email') {
          return EmailToRegisterUserResponse.codeAlreadySent;
        } else {
          return EmailToRegisterUserResponse.invalidData;
        }
      } else {
        throw Exception('Failed to send email: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<CodeWithEmailToRegisterUserResponse> verifyCodeWithEmailToRegisterUser(
      String email, String code) async {
    try {
      final response = await http.post(Uri.parse(
          '${BaseUrlConfig.baseUrl}/$endPoint/verify/code-register?email=$email&code=$code'));

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody == 'Code valid') {
          return CodeWithEmailToRegisterUserResponse.codeValid;
        } else if (responseBody == 'No match code') {
          return CodeWithEmailToRegisterUserResponse.noMatchCode;
        } else if (responseBody == 'There is no code with this email') {
          return CodeWithEmailToRegisterUserResponse.codeExpired;
        } else if (responseBody == 'User already registered') {
          return CodeWithEmailToRegisterUserResponse.userNotRegistered;
        } else {
          return CodeWithEmailToRegisterUserResponse.invalidResponse;
        }
      } else {
        throw Exception('Failed to verify code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error verifying code: $e');
    }
  }

  Future<EmailToResetPasswordResponse> sendEmailToResetPassword(
      String email) async {
    try {
      final response = await http.post(Uri.parse(
          '${BaseUrlConfig.baseUrl}/$endPoint/password/token?email=$email'));
      if (email.isEmpty) {
        return EmailToResetPasswordResponse.unknown;
      } else if (response == 'Email sent sucessfully') {
        return EmailToResetPasswordResponse.sentSuccessfully;
      } else if (response == 'A code has already been sent') {
        return EmailToResetPasswordResponse.codeAlreadySent;
      } else if (response == 'Does not exist an account with this email') {
        return EmailToResetPasswordResponse.accountNotFound;
      } else {
        return EmailToResetPasswordResponse.unknown;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<CodeToResetPasswordResponse> verifyCodeToResetPassword(
      String email, String code) async {
    try {
      final response = await http.post(Uri.parse(
          '${BaseUrlConfig.baseUrl}/$endPoint/verify/code-password?email=$email&code=$code'));

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody == 'Code valid') {
          return CodeToResetPasswordResponse.codeValid;
        } else if (responseBody == 'No match code') {
          return CodeToResetPasswordResponse.noMatchCode;
        } else if (responseBody == 'Does not exist a code with this email') {
          return CodeToResetPasswordResponse.codeExpired;
        } else if (responseBody == 'There is no code with this email') {
          return CodeToResetPasswordResponse.userNotRegistered;
        } else {
          return CodeToResetPasswordResponse.invalidResponse;
        }
      } else {
        throw Exception('Failed to verify code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error verifying code: $e');
    }
  }

  Future<ResetPasswordResponse> resetPassword(
      String email, String newPassword, String confirmPassword) async {
    try {
      final response = await http.put(Uri.parse(
          '${BaseUrlConfig.baseUrl}/users/reset/password?email=$email&newPassword1=$newPassword&newPassword2=$confirmPassword'));

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody == 'Password is updated') {
          return ResetPasswordResponse.passwordUpdated;
        } else if (responseBody == 'Passwords do not match') {
          return ResetPasswordResponse.passwordsMismatch;
        } else {
          return ResetPasswordResponse.invalidResponse;
        }
      } else {
        throw Exception('Failed to reset password: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error resetting password: $e');
    }
  }
}

enum EmailToResetPasswordResponse {
  sentSuccessfully,
  codeAlreadySent,
  accountNotFound,
  unknown,
}

enum EmailToRegisterUserResponse {
  emailSentSuccessfully,
  accountExists,
  codeAlreadySent,
  invalidData,
  termsNotAccepted,
}

enum CodeToResetPasswordResponse {
  codeValid,
  noMatchCode,
  codeExpired,
  userNotRegistered,
  invalidResponse
}

enum CodeWithEmailToRegisterUserResponse {
  codeValid,
  noMatchCode,
  codeExpired,
  userNotRegistered,
  invalidResponse
}

enum ResetPasswordResponse {
  passwordUpdated,
  passwordsMismatch,
  invalidResponse
}
