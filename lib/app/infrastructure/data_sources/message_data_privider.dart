import 'package:http/http.dart' as http;

import '../../config/base_url_config.dart';
import '../models/message_model.dart';

class MessageDataProvider {
  String endPoint = 'messages';

  Future<List<MessageModel>> getMessagesByChatId(int chatId, int userId) async {
    try {
      final response = await http
          .get(Uri.parse('${BaseUrlConfig.baseUrl}/$endPoint/$chatId/$userId'));
      List<MessageModel> messages = MessageModel.fromJsonList(response.body);
      return messages;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
