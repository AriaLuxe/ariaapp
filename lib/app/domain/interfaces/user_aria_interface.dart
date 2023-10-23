import 'package:ariapp/app/presentation/profiles/my_profile/update_email/update_email.dart';

import '../entities/user_aria.dart';

abstract class UserAriaInterface {
  Future<void> signUpUser(UserAria user);
  Future<UserAria> getUserById(int id);
  Future<List<UserAria>> getAllFriends();
  Future<List<UserAria>> searchUser(String keyword);
  Future<List<UserAria>> getFavoriteUsers();
  Future<void> updateUserData(String userId, String name, String lastName, String nickname, String gender, String date, String country, String city);
  Future<String> updateEmail(int userId, String email, String password);
  Future<void> updateUserPassword(int userId, String newPassword, String currentPassword);
  Future<String> updateUserState(int userId, String state);

  Future<List<UserAria>> searchUserByName();
}
