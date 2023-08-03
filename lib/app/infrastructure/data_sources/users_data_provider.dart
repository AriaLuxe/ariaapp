import 'package:ariapp/app/data/services/globals.dart';
import 'package:ariapp/app/domain/models/user_aria_model.dart';
import 'package:http/http.dart' as http;

class UsersDataProvider {
  String endPoint = 'users-aria';
  Future<List<UserAria>> getUsers() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$endPoint"));
      if (response.statusCode == 200) {
        final List<UserAria> users = UserAria.toUserAriaList(response.body);
        return users;
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}
