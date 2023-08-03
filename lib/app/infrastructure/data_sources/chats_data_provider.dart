import 'package:ariapp/app/data/services/globals.dart';
import 'package:ariapp/app/domain/models/chat_model.dart';
import 'package:http/http.dart' as http;

class ChatsDataProvider {
  String endPoint = 'chats';

  Future<List<ChatModel>> getAllChatsByUserId(int id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/$endPoint?userId=$id'));
      List<ChatModel> chats = ChatModel.toChatsList(response.body);
      return chats;
    } catch (error) {
      throw Exception(error);
    }
  }
}
