import 'dart:io';

import 'package:ariapp/app/domain/entities/follower.dart';
import 'package:ariapp/app/domain/entities/user_aria.dart';

abstract class UserAriaInterface {
  Future<List<UserAria>> getUsers(int page, int pageSize);

  Future<String> updateUserEmail(int userId, String email, String password);

  Future<void> signUp(UserAria user);

  Future<UserAria> getUserById(int id);

  Future<List<UserAria>> searchUsers(String keyword);

  Future<String> updateUserData(
      String userId,
      String name,
      String lastName,
      String nickname,
      String gender,
      DateTime date,
      String country,
      String city);

  Future<String> updateUserPassword(
      int userId, String newPassword, String currentPassword);

  Future<String> updateUserState(int userId, String state);

  Future<List<Follower>> getFollowers(int userId, int userLooking);

  Future<List<Follower>> getFollowing(int userId, int userLooking);

  Future<List<Follower>> getSubscribers(int userId);

  Future<int> getFollowersCounter(int userId);

  Future<int> getFollowingCounter(int userId);

  Future<int> getSubscribersCounter(int userId);

  Future<String> follow(int userId, int idReceiver);

  Future<String> unFollow(int idRequest);

  Future<dynamic> checkFollow(int userId, int userLooking);

  Future<String> block(int idBlockingUser, int idBlocked);

  Future<bool> checkBlock(int userId, int userLooking);

  Future<String> unBlock(int idBlockingUser, int idBlocked);

  Future<bool> checkCreator(int userId);

  Future<void> sendSuggestion(int userId, String title, String content);

  Future<bool> validateNickname(String nickname);

  Future<void> sendApplicant(int userId);

  Future<bool> getApplicant(int userId);

  Future<String> updateUserImageProfile(int userId, File image);

  Future<String> deleteAccount(int userId);
}
