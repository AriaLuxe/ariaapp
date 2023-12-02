import 'package:ariapp/app/domain/entities/message.dart';
import 'package:ariapp/app/domain/interfaces/message_interface.dart';
import 'package:ariapp/app/infrastructure/data_sources/message_data_privider.dart';

class MessageRepository extends MessageInterface {
  final MessageDataProvider messageDataProvider;

  MessageRepository({
    required this.messageDataProvider,
  });
  @override
  Future<Message> createMessage(int chatId, int userId, String audioPath) {
    final response = messageDataProvider.createMessage(chatId, userId, audioPath);
  return response;
  }

  @override
  Future<List<Message>> getMessagesByChatId(int chatId, int userId, int page, int pageSize) async {
    final response =
        await messageDataProvider.getMessagesByChatId(chatId, userId, page, pageSize);
    return response;
  }

  @override
  Future<Message> responseMessage(int chatId, int userReceivedId, String audioPath) {
    final response = messageDataProvider.responseMessage(chatId, userReceivedId, audioPath);
    return response;

  }
}
