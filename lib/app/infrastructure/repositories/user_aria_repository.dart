import 'package:ariapp/app/domain/entities/user_aria.dart';
import 'package:ariapp/app/domain/interfaces/user_aria_interface.dart';
import 'package:ariapp/app/infrastructure/data_sources/users_data_provider.dart';

class UserAriaRepository extends UserAriaInterface {
  final UsersDataProvider usersDataProvider;

  UserAriaRepository({required this.usersDataProvider});
  @override
  Future<List<UserAria>> getAllFriends() {
    // TODO: implement getAllFriends
    throw UnimplementedError();
  }

  @override
  Future<List<UserAria>> searchUserByName() {
    // TODO: implement searchUserByName
    throw UnimplementedError();
  }

  @override
  Future<void> updateEmail() {
    // TODO: implement updateEmail
    throw UnimplementedError();
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
  Future<void> updateUserData() {
    // TODO: implement updateUserData
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
}
