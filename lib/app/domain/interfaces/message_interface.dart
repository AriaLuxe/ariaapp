import '../entities/message.dart';

abstract class MessageInterface {
  Future<List<Message>> getMessagesByChatId(int chatId, int userId, int page, int pageSize);
  Future<Message> createMessage(int chatId, int userId, String audioPath);
  Future<Message> responseMessage(int chatId, int userReceivedId, String audioPath);
  Future<void> deleteMessage(int messageId);
  Future<void> likedMessage(int messageId);

}
