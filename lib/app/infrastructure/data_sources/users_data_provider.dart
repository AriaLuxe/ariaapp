import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import '../../config/base_url_config.dart';
import '../../domain/entities/follower.dart';
import '../../domain/entities/user_aria.dart';
import '../../security/shared_preferences_manager.dart';
import '../models/follower_model.dart';
import '../models/user_aria_model.dart';

class UsersDataProvider {
  String endPoint = 'users';

  Future<List<UserAriaModel>> getUsers(int page, int pageSize) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.get(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/$endPoint/list?page=$page&size=$pageSize"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> contentList = json.decode(response.body)['content'];

        final List<UserAriaModel> users = contentList
            .map((content) => UserAriaModel.fromJson(content))
            .toList();
        return users;
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<UserAriaModel>> searchUsers(String keyword) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.get(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/$endPoint/searchUser?keyword=$keyword"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<UserAriaModel> users =
            UserAriaModel.toUserAriaList(response.body);
        return users;
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> signUp(UserAria user) async {
    try {
      final newUser = {
        "nameUser": user.nameUser,
        "lastName": user.lastName,
        "email": user.email,
        "password": user.password,
        "dateBirth": user.dateBirth?.toIso8601String(),
        "gender": user.gender,
        "country": user.country,
        "city": user.city,
        "nickName": user.nickname
      };
      await http.post(
        Uri.parse("${BaseUrlConfig.baseUrl}/$endPoint/add"),
        body: jsonEncode(newUser),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<UserAria> getUserById(int userId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.get(
        Uri.parse('${BaseUrlConfig.baseUrl}/$endPoint/data/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final UserAriaModel user =
          UserAriaModel.fromJson(jsonDecode(response.body));
      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> updateUserData(
      String userId,
      String name,
      String lastName,
      String nickname,
      String gender,
      DateTime date,
      String country,
      String city) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.put(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/$endPoint/data?idUser=$userId&nameUser=$name&lastName=$lastName&gender=$gender&dateBirth=${DateFormat('yyyy-MM-dd HH:mm').format(date)}&country=$country&city=$city&nickName=$nickname"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      return response.body;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> updateUserEmail(
      int userId, String email, String password) async {
    try {
      String? token = await SharedPreferencesManager.getToken();
      print(userId);
      final Uri uri = Uri.parse(
          "${BaseUrlConfig.baseUrl}/$endPoint/email?idUser=$userId&email=$email&password=$password");

      final response = await http.put(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.body);
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> updateUserPassword(
      int userId, String newPassword, String currentPassword) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final Uri uri = Uri.parse(
          "${BaseUrlConfig.baseUrl}/$endPoint/password?idUser=$userId&newPassword=$newPassword&currentPassword=$currentPassword");

      final response = await http.put(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );
      return response.body;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> updateUserState(int userId, String state) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final Uri uri = Uri.parse(
          "${BaseUrlConfig.baseUrl}/$endPoint/state?idUser=$userId&state=$state");

      final response = await http.put(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );
      return response.body;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> updateUserImageProfile(int userId, File image) async {
    try {
      String? token = await SharedPreferencesManager.getToken();
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse("${BaseUrlConfig.baseUrl}/$endPoint/img-Profile"),
      );
      request.fields['idUser'] = userId.toString();

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('file', image.path),
      );
      var response = await request.send();

      if (response.statusCode == 200) {
        return 'imgProfile is updated';
      } else {
        throw Exception('Error en la actualización de la imagen de perfil');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<Follower>> getFollowers(int userId, int userLooking) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.get(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/follow/followers?idUserLogged=$userId&idUserLooking=$userLooking"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return FollowerModel.toFollowerList(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<Follower>> getFollowing(int userId, int userLooking) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.get(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/follow/following?idUserLogged=$userId&idUserLooking=$userLooking"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return FollowerModel.toFollowerList(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<Follower>> getSubscribers(int userId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.get(
        Uri.parse("${BaseUrlConfig.baseUrl}/chats/subscribers?idUser=$userId"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return FollowerModel.toFollowerList(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<int> getFollowersCounter(int userId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.get(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/follow/followers/quantity?idUser=$userId"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<int> getFollowingCounter(int userId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.get(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/follow/following/quantity?idUser=$userId"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<int> getSubscribersCounter(int userId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.get(
        Uri.parse("${BaseUrlConfig.baseUrl}/chats/subscribers?idUser=$userId"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> follow(int userId, int idReceiver) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.post(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/follow/send?idSender=$userId&idReceiver=$idReceiver"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> unFollow(int idRequest) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.delete(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/follow/delete?idRequest=$idRequest"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<dynamic> checkFollow(int userId, int userLooking) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.get(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/follow/is-followed?idUserLogged=$userId&idUserLooking=$userLooking"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> block(int idBlockingUser, int idBlocked) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.post(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/locks/block?idBlockingUser=$idBlockingUser&idBlocked=$idBlocked"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> unBlock(int idBlockingUser, int idBlocked) async {
    try {
      String? token = await SharedPreferencesManager.getToken();
      final response = await http.delete(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/locks/unblock?idBlockingUser=$idBlockingUser&idBlocked=$idBlocked"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

//TODO CHATS BLOCK
  Future<bool> checkBlock(int userId, int userLooking) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.get(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/locks/verify-blocking?idUserLogged=$userId&idUserLooking=$userLooking"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return bool.parse(response.body);
      } else {
        return bool.parse(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<bool> checkCreator(int userId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.get(
        Uri.parse("${BaseUrlConfig.baseUrl}/users/isCreator?idUser=$userId"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return bool.parse(response.body);
      } else {
        return bool.parse(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> deleteAccount(int userId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.delete(
        Uri.parse("${BaseUrlConfig.baseUrl}/users?idUser=$userId"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> sendSuggestion(int userId, String title, String content) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.post(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/suggestion/send?idSender=$userId&title=$title&content=$content"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        log(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

//TODO: get applicant
  Future<void> sendApplicant(int userId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.post(
        Uri.parse("${BaseUrlConfig.baseUrl}/applicant/send?idSender=$userId"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        log(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<bool> validateNickname(String nickname) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.get(
        Uri.parse("${BaseUrlConfig.baseUrl}/users/nickname?nickname=$nickname"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return bool.parse(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}
