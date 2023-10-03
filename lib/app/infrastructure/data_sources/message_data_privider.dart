import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../config/base_url_config.dart';
import '../models/message_model.dart';

class MessageDataProvider {
  String endPoint = 'messages/ordinary';

  Future<List<MessageModel>> getMessagesByChatId(int chatId, int userId) async {
    try {
      print('chat: $chatId');
      print('user: $userId');
      final response = await http
          .get(Uri.parse('${BaseUrlConfig.baseUrl}/$endPoint/$chatId/$userId'));
      print(response.body);

      List<MessageModel> messages = MessageModel.fromJsonList(response.body);
      print(response.body);
      return messages;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<MessageModel> createMessage(int chatId, int userId, String audioPath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${BaseUrlConfig.baseUrl}/$endPoint/add'),
      );

      // Adjunta el archivo al campo "audio" en la solicitud.
      request.files.add(await http.MultipartFile.fromPath(
        'audio',
        audioPath,
        contentType: MediaType('audio', 'mpeg'), // Especifica el tipo de contenido del archivo.
      ));

      // Agrega otros campos de datos si es necesario.
      request.fields['sender'] = userId.toString();
      request.fields['chatId'] = chatId.toString();

      // Envía la solicitud y espera la respuesta.
      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final response = await http.Response.fromStream(streamedResponse);
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


}
