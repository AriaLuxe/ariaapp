part of 'chat_list_bloc.dart';

sealed class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object> get props => [];
}

class ChatsFetched extends ChatListEvent {}

class ChatsAdded extends ChatListEvent {
  final int senderId;
  final int receiverId;

  const ChatsAdded(this.senderId, this.receiverId);
}

class DeleteChat extends ChatListEvent {
  final int chatId;

  const DeleteChat(this.chatId);
}

class SearchChat extends ChatListEvent {
  final String keyword;
  final int userId;

  const SearchChat(this.keyword, this.userId);

  @override
  List<Object> get props => [keyword, userId];
}
