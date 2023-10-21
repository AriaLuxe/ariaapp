import '../entities/user_aria.dart';

abstract class UserAriaInterface {
  Future<void> signUpUser(UserAria user);
  Future<UserAria> getUserById(int id);
  Future<List<UserAria>> getAllFriends();
  Future<List<UserAria>> searchUser(String keyword);
  Future<List<UserAria>> getFavoriteUsers();
  Future<void> updateEmail();
  Future<void> updatePassword();
  Future<void> updateUserData();
  Future<void> updateImgProfile();
  Future<List<UserAria>> searchUserByName();
}
