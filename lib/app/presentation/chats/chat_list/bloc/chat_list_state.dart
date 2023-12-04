part of 'chat_list_bloc.dart';

enum ChatListStatus { initial, loading, error, success }

class ChatListState extends Equatable {
  final List<Chat> chats;
  final List<Chat> chatsSearch;
  final ChatListStatus chatListStatus;
  final bool isLoadingDeleteChat;
  final String responseDeleteChat;
  const ChatListState({
    this.chatListStatus = ChatListStatus.initial,
    this.chats = const <Chat>[],
    this.chatsSearch = const <Chat>[],

    this.isLoadingDeleteChat = false,
    this.responseDeleteChat = '',
  });

  ChatListState copyWith({
    List<Chat>? chats,
    ChatListStatus? chatListStatus,
    bool? isLoadingDeleteChat,
    String? responseDeleteChat,
    List<Chat>? chatsSearch,

  }) {
    return ChatListState(
      chats: chats ?? this.chats,
      chatListStatus: chatListStatus ?? this.chatListStatus,
        isLoadingDeleteChat : isLoadingDeleteChat ?? this.isLoadingDeleteChat,
        responseDeleteChat: responseDeleteChat ?? this.responseDeleteChat,
        chatsSearch: chatsSearch ?? this.chatsSearch
    );
  }

  @override
  List<Object> get props => [isLoadingDeleteChat, chats, chatListStatus,responseDeleteChat,chatsSearch];
}
