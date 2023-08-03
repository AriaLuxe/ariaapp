import 'package:ariapp/app/domain/entities/chat.dart';

abstract class ChatInterface {
  Future<Chat> createChat();
  Future<List<Chat>> getAllChatsByUserId(int id);
  Future<void> deleteChat(int id);
}
