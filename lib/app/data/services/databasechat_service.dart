import 'dart:convert';
import 'package:ariapp/app/data/services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:ariapp/app/domain/models/chat_model.dart';
import 'package:ariapp/app/domain/models/user_aria_model.dart';

class DatabaseUserService {
  static Future<Chat> addChat(
    List<UserAria> users,
  ) async {
    Map data = {
      "users": users,
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseChatURL/add');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    Map responseMap = jsonDecode(response.body);
    Chat chat = Chat.fromMap(responseMap);

    return chat;
  }

  static Future<List<Chat>> getChats() async {
    List<Chat> chats = [];
    /*for (Map userMap in responseList) {
      UserAria userAria = UserAria.fromMap(userMap);
      //here could be code tu add chat instead of tasks.add(task)
    }*/
    return chats;
  }
}
