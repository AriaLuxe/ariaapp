import 'dart:convert';

import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/base_url_config.dart';
import '../models/chat_model.dart';

class ChatsDataProvider {
  String endPoint = 'chats/ordinary';
  Future<List<ChatModel>> getAllChatsByUserId(int id) async {
    try {
      String? token = await SharedPreferencesManager.getToken();
      final response =
          await http.get(Uri.parse('${BaseUrlConfig.baseUrl}/chats/IA/$id'),headers: {
            'Authorization': 'Bearer $token',
          },);
      List<ChatModel> chats = ChatModel.toChatsList(response.body);
      return chats;
    } catch (error) {
      print(error);
      throw Exception(error);
    }
  }

  Future<ChatModel> createChat(int senderId, int receiverId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.post(
        Uri.parse(
            '${BaseUrlConfig.baseUrl}/chats/add/IA/$senderId/$receiverId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      print('response.body 1');
      print('response.body 1');


      print(response.body);

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
  Future<String> validateCreateChat(int senderId, int receiverId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.post(
        Uri.parse(
            '${BaseUrlConfig.baseUrl}/chats/add/IA/$senderId/$receiverId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);

      if (response.body.startsWith('{')) {

        return 'chat created';
      } else if(response.body == 'This user is not a creator' ) {
        return 'This user is not a creator';
      }else {
        return 'error';
      }
    } catch (error) {
      print(error);
      throw Exception(error);
    }
  }

  Future<String> deleteChat(int chatId) async {
    try {

      String? token = await SharedPreferencesManager.getToken();

      final response = await http
          .delete(Uri.parse('${BaseUrlConfig.baseUrl}/chats/delete/$chatId'),headers: {
        'Authorization': 'Bearer $token',
      },);
      return response.body;

    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<List<ChatModel>> searchChats(String keyword, int userId) async {

    try {
      String? token = await SharedPreferencesManager.getToken();

      final response =
      await http.get(Uri.parse("${BaseUrlConfig.baseUrl}/chats/search?keyword=$keyword&idUser=$userId"),headers: {
        'Authorization': 'Bearer $token',
      },);
      if (response.statusCode == 200) {
        final List<ChatModel> chats =
        ChatModel.toChatsList(response.body);
        return chats;
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}
