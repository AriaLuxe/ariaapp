part of 'chat_list_bloc.dart';

enum ChatListStatus { initial, loading, error, success }

class ChatListState extends Equatable {
  final List<Chat> chats;
  final ChatListStatus chatListStatus;

  const ChatListState({
    this.chatListStatus = ChatListStatus.initial,
    this.chats = const <Chat>[],
  });

  ChatListState copyWith({
    List<Chat>? chats,
    ChatListStatus? chatListStatus,
  }) {
    return ChatListState(
      chats: chats ?? this.chats,
      chatListStatus: chatListStatus ?? this.chatListStatus,
    );
  }

  @override
  List<Object> get props => [chats, chatListStatus];
}
