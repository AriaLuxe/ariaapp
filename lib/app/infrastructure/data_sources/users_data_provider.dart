import 'package:http/http.dart' as http;

import '../../config/base_url_config.dart';
import '../models/user_aria_model.dart';

class UsersDataProvider {
  String endPoint = 'users';
  Future<List<UserAriaModel>> getUsers() async {
    try {
      final response =
          await http.get(Uri.parse("${BaseUrlConfig.baseUrl}/$endPoint"));
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
}
