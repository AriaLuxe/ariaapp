import 'package:ariapp/app/infrastructure/repositories/chat_repository.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../../domain/entities/chat.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository chatRepository;

  ChatListBloc()
      : chatRepository = GetIt.instance<ChatRepository>(),
        super(const ChatListState()) {
    on<ChatListEvent>((event, emit) {});
    on<ChatsFetched>(_onChatsFetched);
    on<ChatsAdded>(_onChatAdded);
    on<DeleteChat>(_onDeleteChat);
  }

  Future<void> _onChatsFetched(
    ChatsFetched event,
    Emitter<ChatListState> emit,
  ) async {
    emit(state.copyWith(chatListStatus: ChatListStatus.loading));
   // print(userLogged.userAria.id!);
    try {
      int? userId = await  SharedPreferencesManager.getUserId();
      final List<Chat> chats =
          await chatRepository.getAllChatsByUserId(userId!);
      List<Chat> chatsUpdated = [];
      print('chats.length');
      print(chats.length);

      for (final chat in chats) {
        chatsUpdated.add(chat);
      }
      emit(
        state.copyWith(
          chatListStatus: ChatListStatus.success,
          chats: chatsUpdated,
        ),
      );
      print('entre');
    } catch (e) {
      emit(state.copyWith(chatListStatus: ChatListStatus.error));
    }
  }

  void chatsFetched() {
    add(ChatsFetched());
  }

  Future<void> _onChatAdded(
    ChatsAdded event,
    Emitter<ChatListState> emit,
  ) async {
    emit(state.copyWith(chatListStatus: ChatListStatus.loading));
    try {
      final Chat chat =
          await chatRepository.createChat(event.senderId, event.receiverId);
      List<Chat> chatsUpdated = List.from(state.chats);
      chatsUpdated.add(chat);

      emit(
        state.copyWith(
          chatListStatus: ChatListStatus.success,
          chats: chatsUpdated,
        ),
      );
      print('Chat creado con éxito');
    } catch (e) {
      emit(state.copyWith(chatListStatus: ChatListStatus.error));
      print('Error al crear el chat: $e');
    }
  }

  void chatsAdded(int senderId, int receiverId) {
    add(ChatsAdded(senderId, receiverId));
  }
  Future<void> _onDeleteChat(
      DeleteChat event,
      Emitter<ChatListState> emit,
      ) async {
    try {
      emit(state.copyWith(
        isLoadingDeleteChat: true,
      ));
      final response = await chatRepository.deleteChat(event.chatId);
      print(response);
      if (response == 'Chat is deleted') {
        final List<Chat> updatedChats = List.from(state.chats);
        updatedChats.removeWhere((chat) => chat.chatId == event.chatId);

        emit(state.copyWith(
          chatListStatus: ChatListStatus.success,
          chats: updatedChats,
          isLoadingDeleteChat: false,
        ));
      } else {
        // Maneja el caso en el que la eliminación no fue exitosa
      }
    } catch (e) {
      emit(state.copyWith(chatListStatus: ChatListStatus.error));
      print('Error al eliminar el chat: $e');
    }
  }

  void deleteChat(int chatId) {
    add(DeleteChat(chatId));
  }
}
