import 'package:ariapp/app/infrastructure/repositories/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/io.dart';

import '../../../../domain/entities/chat.dart';
import '../../../../security/user_logged.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository chatRepository;
  final UserLogged userLogged;

  ChatListBloc()
      : chatRepository = GetIt.instance<ChatRepository>(),
        userLogged = GetIt.instance<UserLogged>(),
        super(const ChatListState()) {
    on<ChatListEvent>((event, emit) {});
    on<ChatsFetched>(_onChatsFetched);
    on<ChatsAdded>(_onChatAdded);
  }

  Future<void> _onChatsFetched(
    ChatsFetched event,
    Emitter<ChatListState> emit,
  ) async {
    emit(state.copyWith(chatListStatus: ChatListStatus.loading));
    try {
      final List<Chat> chats =
          await chatRepository.getAllChatsByUserId(userLogged.userAria.id!);
      List<Chat> chatsUpdated = [];

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
      print('entreeee111');
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
}
