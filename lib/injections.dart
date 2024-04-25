import 'package:ariapp/app/domain/entities/user_aria.dart';
import 'package:ariapp/app/infrastructure/data_sources/chats_data_provider.dart';
import 'package:ariapp/app/infrastructure/data_sources/message_data_provider.dart';
import 'package:ariapp/app/infrastructure/data_sources/voice_clone_data_provider.dart';
import 'package:ariapp/app/infrastructure/repositories/chat_repository.dart';
import 'package:ariapp/app/infrastructure/repositories/message_repository.dart';
import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/infrastructure/repositories/voice_repository.dart';
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
