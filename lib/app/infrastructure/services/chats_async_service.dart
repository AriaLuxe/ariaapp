import 'package:ariapp/app/domain/entities/chat.dart';
import 'package:ariapp/app/infrastructure/data_sources/chats_data_provider.dart';
import 'package:ariapp/app/infrastructure/local_data_source/chat_db.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ChatSyncService {
  final ChatsDataProvider chatsDataProvider;
  final ChatDB chatDB;

  ChatSyncService({required this.chatsDataProvider, required this.chatDB});

  Future<void> syncChats(int userId) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.none) {
        await _syncChatsFromServer(userId);
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  Future<void> _syncChatsFromServer(int userId) async {
    final chatsFromServer = await chatsDataProvider.getAllChatsByUserId(userId);
    print(chatsFromServer.length);
    await chatDB.clearChats();
    for (var chat in chatsFromServer) {
      await chatDB.insertChat(chat);
    }
  }

  Future<List<Chat>> getAllChatsByUserId(int userId) async {
    final List<Chat> chats = await chatDB.getChatsByUserId(userId);
    print('chats');
    print(chats);

    return chats;
  }
}
