import 'package:ariapp/app/infrastructure/models/chat_model.dart';
import 'package:ariapp/app/infrastructure/services/data_base_service.dart';
import 'package:sqflite/sqflite.dart';

class ChatDB {
  final String tableName = 'chats';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name_user TEXT NOT NULL,
        last_name TEXT NOT NULL,
        img_profile TEXT NOT NULL,
        last_message TEXT,
        date_last_message INTEGER,
        unread BOOLEAN,
        ia_chat BOOLEAN NOT NULL,
        counter_new_message INTEGER,
        duration_seconds INTEGER,
        FOREIGN KEY (user_id) REFERENCES users_aria (id)
      )
    ''');
  }

  Future<int> insertChat(ChatModel chat) async {
    final database = await DatabaseService().database;

    return await database.rawInsert('''
    INSERT INTO $tableName (
      user_id, name_user, last_name, img_profile,
      last_message, date_last_message, unread,
      ia_chat, counter_new_message, duration_seconds
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  ''', [
      chat.userId,
      chat.nameUser,
      chat.lastName,
      chat.imgProfile,
      chat.lastMessage,
      chat.dateLastMessage?.millisecondsSinceEpoch,
      chat.unread,
      chat.iaChat,
      chat.counterNewMessage,
      chat.durationSeconds,
    ]);
  }

  Future<List<ChatModel>> getChatsByUserId(int userId) async {
    final database = await DatabaseService().database;
    final chats =
        await database.query(tableName, where: 'user_id = ?', whereArgs: [2]);

    return chats.map((chatMap) => ChatModel.fromMap(chatMap)).toList();
  }

  Future<int> deleteChat(int chatId) async {
    final database = await DatabaseService().database;
    return await database
        .delete(tableName, where: 'id = ?', whereArgs: [chatId]);
  }

  Future<void> clearChats() async {
    final database = await DatabaseService().database;
    await database.delete(tableName);
  }
}
