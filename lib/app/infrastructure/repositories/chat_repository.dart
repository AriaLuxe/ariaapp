import 'package:ariapp/app/domain/entities/chat.dart';
import 'package:ariapp/app/domain/interfaces/chat_interface.dart';
import 'package:ariapp/app/infrastructure/data_sources/chats_data_provider.dart';

class ChatRepository extends ChatInterface {
  final ChatsDataProvider chatsDataProvider;

  ChatRepository(this.chatsDataProvider);
  @override
  Future<void> deleteChat(int id) {
    // TODO: implement deleteChat
    throw UnimplementedError();
  }

  @override
  Future<List<Chat>> getAllChatsByUserId(int id) async {
    final response = await chatsDataProvider.getAllChatsByUserId(id);
    return response;
  }

  @override
  Future<Chat> createChat() {
    // TODO: implement createChat
    throw UnimplementedError();
  }
}
