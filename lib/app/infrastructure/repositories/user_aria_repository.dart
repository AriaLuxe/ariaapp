import 'package:ariapp/app/domain/entities/user_aria.dart';
import 'package:ariapp/app/domain/interfaces/user_aria_interface.dart';
import 'package:ariapp/app/infrastructure/data_sources/users_data_provider.dart';

class UserAriaRepository extends UserAriaInterface {
  final UsersDataProvider usersDataProvider;

  UserAriaRepository({required this.usersDataProvider});
  @override
  Future<List<UserAria>> getAllFriends() async {
    final response = await usersDataProvider.getUsers();
    return response;
  }

  @override
  Future<List<UserAria>> searchUserByName() {
    // TODO: implement searchUserByName
    throw UnimplementedError();
  }

  @override
  Future<String> updateEmail(int userId, String email, String password) async {
    return await usersDataProvider.updateUserEmail(userId, email, password);
  }

  @override
  Future<void> updateImgProfile() {
    // TODO: implement updateImgProfile
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword() {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }



  @override
  Future<List<UserAria>> getFavoriteUsers() {
    // TODO: implement getFavoriteUsers
    throw UnimplementedError();
  }

  @override
  Future<void> signUpUser(UserAria user) async {
    await usersDataProvider.signUp(user);
  }

  @override
  Future<UserAria> getUserById(int id) async {
    return await usersDataProvider.getUserById(id);
  }

  @override
  Future<List<UserAria>> searchUser(String keyword) async {
    return await usersDataProvider.searchUsers(keyword);
  }

  @override
  Future<void> updateUserData(String userId, String name, String lastName, String nickname, String gender, String date, String country, String city ) async{
    return await usersDataProvider.updateUserData(userId, name, lastName, nickname, gender, date,country,city);

  }

  @override
  Future<String> updateUserPassword(int userId, String newPassword, String currentPassword)async {
    return await usersDataProvider.updateUserPassword(userId, newPassword, currentPassword);
  }

  @override
  Future<String> updateUserState(int userId, String state) async {
    return await usersDataProvider.updateUserState(userId, state);
  }
}
