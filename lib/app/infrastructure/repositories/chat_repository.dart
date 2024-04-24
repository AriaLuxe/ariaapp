import 'package:ariapp/app/domain/entities/chat.dart';
import 'package:ariapp/app/domain/interfaces/chat_interface.dart';
import 'package:ariapp/app/infrastructure/data_sources/chats_data_provider.dart';

class ChatRepository extends ChatInterface {
  final ChatsDataProvider chatsDataProvider;

  ChatRepository({required this.chatsDataProvider});

  @override
  Future<String> deleteChat(int chatId) async {
    final response = await chatsDataProvider.deleteChat(chatId);
    return response;
  }

  @override
  Future<List<Chat>> getAllChatsByUserId(int id) async {
    final response = await chatsDataProvider.getAllChatsByUserId(id);
    return response;
  }

  @override
  Future<dynamic> createChat(int senderId, int receiverId) {
    return chatsDataProvider.createChat(senderId, receiverId);
  }

  @override
  Future<List<Chat>> searchChats(String keyword, int userId) {
    return chatsDataProvider.searchChats(keyword, userId);
  }

  @override
  Future<String> validateCreateChat(int senderId, int receiverId) {
    return chatsDataProvider.validateCreateChat(senderId, receiverId);
  }
}
