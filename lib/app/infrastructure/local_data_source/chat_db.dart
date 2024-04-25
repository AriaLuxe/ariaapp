// import 'package:ariapp/app/infrastructure/models/chat_model.dart';
// import 'package:ariapp/app/infrastructure/services/data_base_service.dart';
// import 'package:sqflite/sqflite.dart';

// class ChatDB {
//   final String tableName = 'chats';

//   Future<void> createTable(Database database) async {
//     await database.execute('''
//       CREATE TABLE IF NOT EXISTS $tableName (
//         id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
//         user_id INTEGER NOT NULL,
//         name_user TEXT NOT NULL,
//         last_name TEXT NOT NULL,
//         img_profile TEXT NOT NULL,
//         last_message TEXT,
//         date_last_message INTEGER,
//         unread INTEGER,
//         ia_chat INTEGER NOT NULL,
//         counter_new_message INTEGER,
//         duration_seconds INTEGER,
//         FOREIGN KEY (user_id) REFERENCES users_aria (id)
//       )
//     ''');
//   }

//   Future<int> insertChat(ChatModel chat) async {
//     final database = await DatabaseService().database;
//     return await database.insert(tableName, chat.toJson());
//   }

//   Future<List<ChatModel>> getChatsByUserId(int userId) async {
//     final database = await DatabaseService().database;
//     final chats = await database
//         .query(tableName, where: 'user_id = ?', whereArgs: [userId]);
//     return chats.map((chatMap) => ChatModel.fromMap(chatMap)).toList();
//   }

//   Future<int> deleteChat(int chatId) async {
//     final database = await DatabaseService().database;
//     return await database
//         .delete(tableName, where: 'id = ?', whereArgs: [chatId]);
//   }
// }
