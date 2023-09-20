import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const _keyUserId = 'user_id';

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
}
