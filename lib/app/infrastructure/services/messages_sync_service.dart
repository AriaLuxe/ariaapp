import 'dart:developer';

import 'package:ariapp/app/infrastructure/data_sources/message_data_privider.dart';
import 'package:ariapp/app/infrastructure/local_data_source/message_db.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MessageSyncService {
  final MessageDataProvider messageDataProvider;
  final MessageDB messageDB;

  MessageSyncService(
      {required this.messageDataProvider, required this.messageDB});

  Future<void> syncMessages(
    int chatId,
    int userId,
    int page,
    int pageSize,
  ) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.none) {
        // Si hay conexión a internet, sincroniza los mensajes
        await _syncMessagesFromServer(chatId, userId, page, pageSize);
      } else {
        return;
      }
    } catch (e) {
      // Maneja errores de sincronización
      log('Error de sincronización de mensajes: $e');
    }
  }

  Future<void> _syncMessagesFromServer(
    int chatId,
    int userId,
    int page,
    int pageSize,
  ) async {
    final messagesFromServer = await messageDataProvider.getMessagesByChatId(
        chatId, userId, page, pageSize);

    await messageDB.clearMessages();
    for (var message in messagesFromServer) {
      await messageDB.insertMessage(message);
    }
  }
}
