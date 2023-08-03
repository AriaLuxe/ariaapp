import 'package:http/http.dart' as http;

import '../../config/base_url_config.dart';
import '../models/chat_model.dart';

class ChatsDataProvider {
  String endPoint = 'chats';
  Future<List<ChatModel>> getAllChatsByUserId(int id) async {
    try {
      final response = await http
          .get(Uri.parse('${BaseUrlConfig.baseUrl}/$endPoint?userId=$id'));
      List<ChatModel> chats = ChatModel.toChatsList(response.body);
      return chats;
    } catch (error) {
      throw Exception(error);
    }
  }
}
