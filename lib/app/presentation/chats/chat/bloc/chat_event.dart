part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class MessageFetched extends ChatEvent {
  final int chatId;
  final int page;
  final int pageSize;

  const MessageFetched(this.chatId, this.page, this.pageSize);
}
class MessageSent extends ChatEvent {
  final int chatId;
  final String audioPath;
  final int userReceivedId;
  const MessageSent( this.chatId, this.audioPath, this.userReceivedId);


}

class ShowPlayer extends ChatEvent {
  final bool isRecording;

  const ShowPlayer( this.isRecording);
}

class AudioPathToSent extends ChatEvent {
  final String path;

  const AudioPathToSent( this.path);
}

class DataChatFetched extends ChatEvent {
  final int userId;
  const DataChatFetched(this.userId);
}
class ClearMessages extends ChatEvent {

  const ClearMessages();
}
class CreateChat extends ChatEvent {
  final int senderId;
  final int receiverId;
  const CreateChat(this.senderId, this.receiverId);
}
class LoadMoreMessages extends ChatEvent {
  const LoadMoreMessages(
     this.chatId,
     this.page,
     this.pageSize,
  );

  final int chatId;
  final int page;
  final int pageSize;

  @override
  List<Object> get props => [chatId, page, pageSize];
}