/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ariapp/app/data/services/globals.dart';
import 'package:ariapp/app/domain/models/message_model.dart';
import 'package:ariapp/app/domain/models/user_aria_model.dart';

class DatabaseMessageService {
  static Future<Message> addMessage(
    UserAria sender,
    DateTime time,
    String content,
    bool isLiked,
    bool unread,
  ) async {
    Map data = {
      "sender": sender,
      "time": time,
      "content": content,
      "isLiked": isLiked,
      "unread": unread,
    };

    var body = json.encode(data);
    var url = Uri.parse(baseMessageURL + '/add');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    Map responseMap = jsonDecode(response.body);
    Message message = Message.fromMap(responseMap);

    return message;
  }

  static Future<List<Message>> getMessages() async {
    var url = Uri.parse(baseMessageURL);
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    List responseList = jsonDecode(response.body);
    List<Message> messages = [];
    /*for (Map userMap in responseList) {
      UserAria userAria = UserAria.fromMap(userMap);
      //here could be code tu add chat instead of tasks.add(task)
    }*/
    return messages;
  }
}*/
