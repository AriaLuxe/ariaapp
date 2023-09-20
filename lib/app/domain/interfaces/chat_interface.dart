import 'package:ariapp/app/domain/entities/chat.dart';

abstract class ChatInterface {
  Future<Chat> createChat(int senderId, int receiverId);
  Future<List<Chat>> getAllChatsByUserId(int id);
  Future<void> deleteChat(int id);
}
