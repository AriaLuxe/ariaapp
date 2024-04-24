import 'dart:convert';

import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/base_url_config.dart';
import '../models/chat_model.dart';

class ChatsDataProvider {
  String endPoint = 'chats/ordinary';

  Future<dynamic> createChat(int senderId, int receiverId) async {
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

      if (response.statusCode == 200) {
        final createdChat = ChatModel.fromMap(jsonDecode(response.body));

        return createdChat;
      } else if (response.statusCode == 400) {
        final responseBody = response.body;
        if (responseBody == 'This user is not a creator') {
          return CreateChatResponse.userNotCreator;
        } else if (responseBody == 'Same user') {
          return CreateChatResponse.sameUser;
        } else {
          return CreateChatResponse.unknownError;
        }
      } else {
        throw Exception('Error al crear el chat: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<ChatModel>> getAllChatsByUserId(int id) async {
    try {
      String? token = await SharedPreferencesManager.getToken();
      final response = await http.get(
        Uri.parse('${BaseUrlConfig.baseUrl}/chats/IA/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      List<ChatModel> chats = ChatModel.toChatsList(response.body);

      return chats;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<ChatModel>> searchChats(String keyword, int userId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.get(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/chats/search?keyword=$keyword&idUser=$userId"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<ChatModel> chats = ChatModel.toChatsList(response.body);
        return chats;
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> deleteChat(int chatId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.delete(
        Uri.parse('${BaseUrlConfig.baseUrl}/chats/delete/$chatId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      return response.body;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> validateCreateChat(int senderId, int receiverId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.delete(
        Uri.parse(
            '${BaseUrlConfig.baseUrl}/chats/delete?idUserLogged=$senderId&idUserLooking=$receiverId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      return response.body;
    } catch (error) {
      throw Exception(error);
    }
  }
}

enum CreateChatResponse { chatCreated, userNotCreator, sameUser, unknownError }
