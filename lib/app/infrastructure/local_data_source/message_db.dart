import 'package:ariapp/app/infrastructure/models/message_model.dart';
import 'package:ariapp/app/infrastructure/services/data_base_service.dart';
import 'package:sqflite/sqflite.dart';

class MessageDB {
  final String tableName = 'messages';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        sender INTEGER NOT NULL,
        content BLOB NOT NULL,
        duration_seconds INTEGER NOT NULL,
        date INTEGER NOT NULL,
        read INTEGER NOT NULL,
        is_liked INTEGER NOT NULL,
        chat_id INTEGER NOT NULL,
        FOREIGN KEY (chat_id) REFERENCES chats (id)
      )
    ''');
  }

  Future<int> insertMessage(MessageModel message) async {
    final database = await DatabaseService().database;
    return await database.insert(tableName, message.toJson());
  }

  Future<List<MessageModel>> getMessagesByChatId(int chatId) async {
    final database = await DatabaseService().database;
    final messages = await database
        .query(tableName, where: 'chat_id = ?', whereArgs: [chatId]);
    return messages
        .map((messageMap) => MessageModel.fromJson(messageMap))
        .toList();
  }

  Future<int> deleteMessage(int messageId) async {
    final database = await DatabaseService().database;
    return await database
        .delete(tableName, where: 'id = ?', whereArgs: [messageId]);
  }
}
