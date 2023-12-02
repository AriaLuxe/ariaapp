part of 'chat_list_bloc.dart';

enum ChatListStatus { initial, loading, error, success }

class ChatListState extends Equatable {
  final List<Chat> chats;
  final ChatListStatus chatListStatus;
  final bool isLoadingDeleteChat;
  const ChatListState({
    this.chatListStatus = ChatListStatus.initial,
    this.chats = const <Chat>[],
    this.isLoadingDeleteChat = false,
  });

  ChatListState copyWith({
    List<Chat>? chats,
    ChatListStatus? chatListStatus,
    bool? isLoadingDeleteChat
  }) {
    return ChatListState(
      chats: chats ?? this.chats,
      chatListStatus: chatListStatus ?? this.chatListStatus,
        isLoadingDeleteChat : isLoadingDeleteChat ?? this.isLoadingDeleteChat,
    );
  }

  @override
  List<Object> get props => [isLoadingDeleteChat, chats, chatListStatus];
}
