import '../entities/user_aria.dart';

abstract class UserAriaInterface {
  Future<List<UserAria>> getAllFriends();
  Future<List<UserAria>> getFavoriteUsers();
  Future<void> updateEmail();
  Future<void> updatePassword();
  Future<void> updateUserData();
  Future<void> updateImgProfile();
  Future<List<UserAria>> searchUserByName();
}
