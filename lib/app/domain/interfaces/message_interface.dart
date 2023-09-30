import '../entities/message.dart';

abstract class MessageInterface {
  Future<List<Message>> getMessagesByChatId(int chatId, int userId);
  Future<Message> addMessage();
}
