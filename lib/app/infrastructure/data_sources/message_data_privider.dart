import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../config/base_url_config.dart';
import '../../security/shared_preferences_manager.dart';
import '../models/message_model.dart';

class MessageDataProvider {
  String endPoint = 'messages/ordinary';

  Future<List<MessageModel>> getMessagesByChatId(int chatId, int userId, int page, int pageSize) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.get(
        Uri.parse('${BaseUrlConfig.baseUrl}/messages/IA/$chatId/$userId?page=$page&pageSize=$pageSize'),
        headers: {'Authorization': 'Bearer $token'},
      );

      List<dynamic> contentList = json.decode(response.body)['content'];

      // Mapea la lista de contenido a una lista de MessageModel
      List<MessageModel> messages = contentList.map((content) => MessageModel.fromJson(content)).toList();

      return messages;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }


  Future<MessageModel> createMessage(int chatId, int userId, String audioPath) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${BaseUrlConfig.baseUrl}/$endPoint/add'),

      );
      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(await http.MultipartFile.fromPath(
        'audio',
        audioPath,
        contentType: MediaType('audio', 'mpeg'),
      ));

      request.fields['sender'] = userId.toString();
      request.fields['chatId'] = chatId.toString();

      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        final response = await http.Response.fromStream(streamedResponse);
        print('response.body1');
        print(response.body);
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return MessageModel.fromJson(responseData);
      } else {
        throw Exception('Error en la solicitud: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
  Future<MessageModel> responseMessage(int chatId, int userReceived, String audioPath) async {
    try {
      print(userReceived);
      print(chatId);

      String? token = await SharedPreferencesManager.getToken();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${BaseUrlConfig.baseUrl}/messages/IA/add'),

      );
      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(await http.MultipartFile.fromPath(
        'audio',
        audioPath,
        contentType: MediaType('audio', 'mpeg'),
      ));

      request.fields['sender'] = userReceived.toString();
      request.fields['chatId'] = chatId.toString();

      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        final response = await http.Response.fromStream(streamedResponse);
        print('response.body1');
        print(response.body);
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return MessageModel.fromJson(responseData);
      } else {
        throw Exception('Error en la solicitud: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<void> deleteMessage(int messageId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.delete(
        Uri.parse('${BaseUrlConfig.baseUrl}/messages/delete/$messageId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print(response);

    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
  Future<void> likedMessage(int messageId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.put(
        Uri.parse('${BaseUrlConfig.baseUrl}/messages/like?idMessage=$messageId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print(response.body);

    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
