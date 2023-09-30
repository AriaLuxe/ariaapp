import 'package:ariapp/app/infrastructure/repositories/message_repository.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../../domain/entities/message.dart';
import '../../../../security/user_logged.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessageRepository messageRepository;

  ChatBloc()
      : messageRepository = GetIt.instance<MessageRepository>(),
        super(const ChatState()) {
    on<ChatEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<MessageFetched>(_onMessageFetched);
  }

  Future<void> _onMessageFetched(
    MessageFetched event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(chatStatus: ChatStatus.loading));
    try {
      final userLogged = GetIt.instance<UserLogged>();

      final List<Message> messages = await messageRepository
          .getMessagesByChatId(event.chatId, userLogged.userAria.id!);
      print(messages);
      emit(state.copyWith(messages: messages, chatStatus: ChatStatus.success));
    } catch (e) {
      print(e);
      emit(state.copyWith(chatStatus: ChatStatus.error));
    }
  }

  void messageFetched(int id) {
    add(MessageFetched(id));
  }
}
