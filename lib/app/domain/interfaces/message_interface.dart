import '../entities/message.dart';

abstract class MessageInterface {
  Future<List<Message>> getMessagesByChatId(
      int chatId, int userId, int page, int pageSize);
  Future<dynamic> getFavoritesMessages(int userLogged, int idUserLooking);

  Future<Message> createMessage(
      int chatId, int userId, String audioPath, String text);

  Future<Message> responseMessage(
      int chatId, int userReceivedId, String audioPath, String text);

  Future<void> deleteMessage(int messageId);

  Future<void> likedMessage(int messageId);

  Future<Message> createTextMessage(int chatId, int userId, String textMessage);

  Future<bool> isReadyToTraining(int userLogged, int chatId);

  Future<void> createTraining(int userId, int chatId);

  Future<void> sendTraining(int userId, int chatId);
}
