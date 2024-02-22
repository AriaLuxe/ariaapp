import 'package:ariapp/app/domain/entities/user_aria.dart';
import 'package:ariapp/app/infrastructure/data_sources/chats_data_provider.dart';
import 'package:ariapp/app/infrastructure/data_sources/message_data_privider.dart';
import 'package:ariapp/app/infrastructure/data_sources/voice_clone_data_provider.dart';
import 'package:ariapp/app/infrastructure/local_data_source/chat_db.dart';
import 'package:ariapp/app/infrastructure/local_data_source/message_db.dart';
import 'package:ariapp/app/infrastructure/repositories/chat_repository.dart';
import 'package:ariapp/app/infrastructure/repositories/message_repository.dart';
import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/infrastructure/repositories/voice_repository.dart';
import 'package:ariapp/app/infrastructure/services/chats_async_service.dart';
import 'package:ariapp/app/infrastructure/services/messages_sync_service.dart';
import 'package:get_it/get_it.dart';

import 'app/infrastructure/data_sources/users_data_provider.dart';
import 'app/security/user_logged.dart';

final serviceLocator = GetIt.instance;

void usersDependencies() {
  serviceLocator
      .registerLazySingleton<UsersDataProvider>(() => UsersDataProvider());
  serviceLocator.registerLazySingleton<UserAriaRepository>(() =>
      UserAriaRepository(
          usersDataProvider: serviceLocator<UsersDataProvider>()));
}

void chatsDependencies() {
  serviceLocator
      .registerLazySingleton<ChatsDataProvider>(() => ChatsDataProvider());
  serviceLocator.registerLazySingleton<ChatRepository>(() =>
      ChatRepository(chatsDataProvider: serviceLocator<ChatsDataProvider>()));
}

void messagesDependencies() {
  serviceLocator
      .registerLazySingleton<MessageDataProvider>(() => MessageDataProvider());
  serviceLocator.registerLazySingleton<MessageRepository>(() =>
      MessageRepository(
          messageDataProvider: serviceLocator<MessageDataProvider>()));
}

void voiceDependencies() {
  serviceLocator.registerLazySingleton<VoiceCloneDataProvider>(
      () => VoiceCloneDataProvider());
  serviceLocator.registerLazySingleton<VoiceRepository>(() => VoiceRepository(
      voiceCloneDataProvider: serviceLocator<VoiceCloneDataProvider>()));
}

void userLogged(UserAria user) {
  serviceLocator
      .registerLazySingleton<UserLogged>(() => UserLogged(user: user));
}

void syncChatsAndMessages() {
  // Registro de ChatDataProvider y ChatDB para la sincronización de chats

  serviceLocator.registerLazySingleton<ChatDB>(() => ChatDB());
  serviceLocator.registerLazySingleton<ChatSyncService>(() => ChatSyncService(
        chatsDataProvider: serviceLocator<ChatsDataProvider>(),
        chatDB: serviceLocator<ChatDB>(),
      ));

  // Registro de MessageDataProvider y MessageDB para la sincronización de mensajes

  serviceLocator.registerLazySingleton<MessageDB>(() => MessageDB());
  serviceLocator
      .registerLazySingleton<MessageSyncService>(() => MessageSyncService(
            messageDataProvider: serviceLocator<MessageDataProvider>(),
            messageDB: serviceLocator<MessageDB>(),
          ));
}
