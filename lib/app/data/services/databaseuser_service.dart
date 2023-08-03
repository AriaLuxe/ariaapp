import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ariapp/app/data/services/globals.dart';
import 'package:ariapp/app/domain/models/user_aria_model.dart';

class DatabaseUserService {
  static Future<UserAria> addUser(
    String nameUser,
    String lastName,
    String email,
    String password,
    bool enabled,
    DateTime registerDate,
  ) async {
    Map data = {
      "nameUser": nameUser,
      "lastName": nameUser,
      "email": nameUser,
      "password": nameUser,
      "enabled": nameUser,
      "registerDate": nameUser,
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseUserURL/add');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    Map responseMap = jsonDecode(response.body);
    UserAria userAria = UserAria.fromMap(responseMap);

    return userAria;
  }

  static Future<List<UserAria>> getUsers() async {
    List<UserAria> users = [];
    /*for (Map userMap in responseList) {
      UserAria userAria = UserAria.fromMap(userMap);
      //here could be code tu add chat instead of tasks.add(task)
    }*/
    return users;
  }
}
