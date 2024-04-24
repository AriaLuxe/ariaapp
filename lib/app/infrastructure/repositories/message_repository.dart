import 'package:ariapp/app/domain/entities/message.dart';
import 'package:ariapp/app/domain/interfaces/message_interface.dart';
import 'package:ariapp/app/infrastructure/data_sources/message_data_provider.dart';

class MessageRepository extends MessageInterface {
  final MessageDataProvider messageDataProvider;

  MessageRepository({
    required this.messageDataProvider,
  });

  @override
  Future<Message> createMessage(
      int chatId, int userId, String audioPath, String text) {
    final response =
        messageDataProvider.createMessage(chatId, userId, audioPath, text);
    return response;
  }

  @override
  Future<List<Message>> getMessagesByChatId(
      int chatId, int userId, int page, int pageSize) async {
    final response = await messageDataProvider.getMessagesByChatId(
        chatId, userId, page, pageSize);
    return response;
  }

  @override
  Future<Message> responseMessage(
      int chatId, int userReceivedId, String audioPath, String text) {
    final response = messageDataProvider.responseMessage(
        chatId, userReceivedId, audioPath, text);
    return response;
  }

  @override
  Future<void> deleteMessage(int messageId) {
    final response = messageDataProvider.deleteMessage(messageId);
    return response;
  }

  @override
  Future<void> likedMessage(int messageId) {
    final response = messageDataProvider.likedMessage(messageId);
    return response;
  }

  @override
  Future<dynamic> getFavoritesMessages(int userLogged, int idUserLooking) {
    final response =
        messageDataProvider.getFavoritesMessages(userLogged, idUserLooking);
    return response;
  }

  @override
  Future<bool> isReadyToTraining(int userLogged, int chatId) async {
    final response = messageDataProvider.isReadyToTraining(userLogged, chatId);
    return response;
  }

  @override
  Future<Message> createTextMessage(
      int chatId, int userId, String textMessage) {
    final response =
        messageDataProvider.createTextMessage(chatId, userId, textMessage);
    return response;
  }

  @override
  Future<void> createTraining(int userId, int chatId) {
    return messageDataProvider.createTraining(userId, chatId);
  }

  @override
  Future<void> sendTraining(int userId, int chatId) {
    return messageDataProvider.sendTraining(userId, chatId);
  }
}
