import 'dart:io';

import 'package:ariapp/app/domain/entities/follower.dart';
import 'package:ariapp/app/domain/entities/user_aria.dart';
import 'package:ariapp/app/domain/interfaces/user_aria_interface.dart';
import 'package:ariapp/app/infrastructure/data_sources/users_data_provider.dart';

class UserAriaRepository extends UserAriaInterface {
  final UsersDataProvider usersDataProvider;

  UserAriaRepository({required this.usersDataProvider});

  @override
  Future<List<UserAria>> getUsers(int page, int pageSize) async {
    final response = await usersDataProvider.getUsers(page, pageSize);
    return response;
  }

  @override
  Future<String> updateUserEmail(
      int userId, String email, String password) async {
    return await usersDataProvider.updateUserEmail(userId, email, password);
  }

  @override
  Future<void> signUp(UserAria user) async {
    await usersDataProvider.signUp(user);
  }

  @override
  Future<UserAria> getUserById(int id) async {
    return await usersDataProvider.getUserById(id);
  }

  @override
  Future<List<UserAria>> searchUsers(String keyword) async {
    return await usersDataProvider.searchUsers(keyword);
  }

  @override
  Future<String> updateUserData(
      String userId,
      String name,
      String lastName,
      String nickname,
      String gender,
      DateTime date,
      String country,
      String city) async {
    return await usersDataProvider.updateUserData(
        userId, name, lastName, nickname, gender, date, country, city);
  }

  @override
  Future<String> updateUserPassword(
      int userId, String newPassword, String currentPassword) async {
    return await usersDataProvider.updateUserPassword(
        userId, newPassword, currentPassword);
  }

  @override
  Future<String> updateUserState(int userId, String state) async {
    return await usersDataProvider.updateUserState(userId, state);
  }

  @override
  Future<List<Follower>> getFollowers(int userId, int userLooking) async {
    return await usersDataProvider.getFollowers(userId, userLooking);
  }

  @override
  Future<List<Follower>> getFollowing(int userId, int userLooking) async {
    return await usersDataProvider.getFollowing(userId, userLooking);
  }

  @override
  Future<List<Follower>> getSubscribers(int userId) async {
    return await usersDataProvider.getSubscribers(userId);
  }

  @override
  Future<int> getFollowersCounter(int userId) async {
    return await usersDataProvider.getFollowersCounter(userId);
  }

  @override
  Future<int> getFollowingCounter(int userId) async {
    return await usersDataProvider.getFollowingCounter(userId);
  }

  @override
  Future<int> getSubscribersCounter(int userId) async {
    return await usersDataProvider.getSubscribersCounter(userId);
  }

  @override
  Future<String> follow(int userId, int idReceiver) async {
    return await usersDataProvider.follow(userId, idReceiver);
  }

  @override
  Future<String> unFollow(int idRequest) async {
    return await usersDataProvider.unFollow(idRequest);
  }

  @override
  Future<dynamic> checkFollow(int userId, int userLooking) async {
    return await usersDataProvider.checkFollow(userId, userLooking);
  }

  @override
  Future<String> block(int idBlockingUser, int idBlocked) async {
    return await usersDataProvider.block(idBlockingUser, idBlocked);
  }

  @override
  Future<bool> checkBlock(int userId, int userLooking) async {
    return await usersDataProvider.checkBlock(userId, userLooking);
  }

  @override
  Future<String> unBlock(int idBlockingUser, int idBlocked) async {
    return await usersDataProvider.unBlock(idBlockingUser, idBlocked);
  }

  @override
  Future<bool> checkCreator(int userId) async {
    return await usersDataProvider.checkCreator(userId);
  }

  @override
  Future<void> sendSuggestion(int userId, String title, String content) async {
    return await usersDataProvider.sendSuggestion(userId, title, content);
  }

  @override
  Future<bool> validateNickname(String nickname) async {
    return await usersDataProvider.validateNickname(nickname);
  }

  @override
  Future<void> sendApplicant(int userId) async {
    return await usersDataProvider.sendApplicant(userId);
  }

  @override
  Future<bool> getApplicant(int userId) async {
    return await usersDataProvider.getApplicant(userId);
  }

  @override
  Future<String> updateUserImageProfile(int userId, File image) async {
    return await usersDataProvider.updateUserImageProfile(userId, image);
  }

  @override
  Future<String> deleteAccount(int userId) async {
    return await usersDataProvider.deleteAccount(userId);
  }
}
