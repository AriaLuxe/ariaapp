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
        read BOOLEAN NOT NULL,
        is_liked BOOLEAN NOT NULL,
        chat_id INTEGER NOT NULL,
        FOREIGN KEY (chat_id) REFERENCES chats (id)
      )
    ''');
  }

  Future<int> insertMessage(MessageModel message) async {
    final database = await DatabaseService().database;
    return await database.rawInsert('''
    INSERT INTO $tableName (
      sender, content, duration_seconds, date,
      read, is_liked, chat_id
    ) VALUES (?, ?, ?, ?, ?, ?, ?)
  ''', [
      message.sender,
      message.content,
      message.durationSeconds,
      message.date?.millisecondsSinceEpoch,
      message.read,
      message.isLiked,
      message.id,
    ]);
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

  Future<void> clearMessages() async {
    final database = await DatabaseService().database;
    await database.delete(tableName);
  }
}
