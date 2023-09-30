import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/base_url_config.dart';
import '../models/chat_model.dart';

class ChatsDataProvider {
  String endPoint = 'chats/ordinary';
  Future<List<ChatModel>> getAllChatsByUserId(int id) async {
    try {
      final response =
          await http.get(Uri.parse('${BaseUrlConfig.baseUrl}/$endPoint/$id'));
      List<ChatModel> chats = ChatModel.toChatsList(response.body);
      return chats;
    } catch (error) {
      print(error);
      throw Exception(error);
    }
  }

  Future<ChatModel> createChat(int senderId, int receiverId) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${BaseUrlConfig.baseUrl}/chats/add/ordinary/$senderId/$receiverId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final createdChat = ChatModel.fromMap(jsonDecode(response.body));
        print('todo nice creado: ');
        print(response.body);

        return createdChat;
      } else {
        throw Exception('Error al crear el chat: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      throw Exception(error);
    }
  }
}
