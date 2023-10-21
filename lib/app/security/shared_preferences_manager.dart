import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const _keyUserId = 'idUser';
  static const _keyEmail = 'email';
  static const _keyToken = 'token';


  static Future<void> saveUserId(int userId) async {
    final preference = await SharedPreferences.getInstance();
    await preference.setInt(_keyUserId, userId);
  }

  static Future<int?> getUserId() async {
    final preference = await SharedPreferences.getInstance();
    return preference.getInt(_keyUserId);
  }

  static Future<void> clearUserId() async {
    final preference = await SharedPreferences.getInstance();
    await preference.remove(_keyUserId);
  }

  static Future<void> saveEmail(String email) async {
    final preference = await SharedPreferences.getInstance();
    await preference.setString(_keyEmail, email);
  }

  static Future<String?> getEmail() async {
    final preference = await SharedPreferences.getInstance();
    return preference.getString(_keyEmail);
  }

  static Future<void> clearEmail() async {
    final preference = await SharedPreferences.getInstance();
    await preference.remove(_keyEmail);
  }

  static Future<void> saveToken(String token) async {
    final preference = await SharedPreferences.getInstance();
    await preference.setString(_keyToken , token);
  }

  static Future<String?> getToken() async {
    final preference = await SharedPreferences.getInstance();
    return preference.getString(_keyToken );
  }

  static Future<void> clearToken() async {
    final preference = await SharedPreferences.getInstance();
    await preference.remove(_keyToken);
  }
}
