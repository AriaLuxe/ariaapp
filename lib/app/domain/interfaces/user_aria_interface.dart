import 'package:ariapp/app/presentation/profiles/my_profile/update_email/update_email.dart';

import '../entities/follower.dart';
import '../entities/user_aria.dart';

abstract class UserAriaInterface {
  Future<void> signUpUser(UserAria user);
  Future<UserAria> getUserById(int id);
  Future<List<UserAria>> getAllFriends();
  Future<List<UserAria>> searchUser(String keyword);
  Future<List<UserAria>> getFavoriteUsers();
  Future<void> updateUserData(String userId, String name, String lastName, String nickname, String gender, DateTime date, String country, String city);
  Future<String> updateEmail(int userId, String email, String password);
  Future<void> updateUserPassword(int userId, String newPassword, String currentPassword);
  Future<String> updateUserState(int userId, String state);
  Future<List<Follower>> getFollowers(int userId, int userLooking);
  Future<List<Follower>> getFollowing(int userId, int userLooking);
  Future<List<Follower>> getSubscribers(int userId);
  Future<int> getFollowersCounter(int userId);
  Future<int> getFollowingCounter(int userId);
  Future<int> getSubscribersCounter(int userId);
  Future<String> follow(int userId, int idReceiver);
  Future<String> unFollow(int idRequest);
  Future<List<UserAria>> searchUserByName();
  Future<dynamic> checkFollow(int userId, int userLooking);

  Future<bool> checkBlock(int userId, int userLooking);
    Future<String> unBlock(int idBlockingUser, int idBlocked);
      Future<String> block(int idBlockingUser, int idBlocked);



  }
