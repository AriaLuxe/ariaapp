part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

final class TextMessage extends ChatEvent {
  const TextMessage(this.textMessage);

  final String textMessage;
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
  final String text;
  final TypeMsg typeMsg;

  const MessageSent(
    this.chatId,
    this.audioPath,
    this.userReceivedId,
    this.text,
    this.typeMsg,
  );
}

class ShowPlayer extends ChatEvent {
  final bool isRecording;

  const ShowPlayer(this.isRecording);
}

class AudioPathToSent extends ChatEvent {
  final String path;

  const AudioPathToSent(this.path);
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

class SelectedMessage extends ChatEvent {
  final int index;
  final int userId;

  const SelectedMessage(this.index, this.userId);

  @override
  List<Object> get props => [index, userId];
}

class DeleteMessage extends ChatEvent {
  final int messageId;
  final int index;

  const DeleteMessage(this.messageId, this.index);
}

class CheckBlock extends ChatEvent {
  final int userLooking;

  const CheckBlock(this.userLooking);
}

class CheckBlockMeYou extends ChatEvent {
  final int userLooking;

  const CheckBlockMeYou(this.userLooking);
}

class ToggleBlockMe extends ChatEvent {
  final bool block;

  const ToggleBlockMe(this.block);
}

class CheckIsCreator extends ChatEvent {
  final int userId;

  const CheckIsCreator(this.userId);
}

class IsReadyTraining extends ChatEvent {
  final int chatId;

  const IsReadyTraining(this.chatId);
}
