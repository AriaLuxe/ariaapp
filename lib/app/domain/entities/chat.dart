import 'package:ariapp/app/domain/entities/user_aria.dart';

class Chat {
  final int chatId;
  final int userId;
  final String nameUser;
  final String lastName;
  final String imgProfile;
  final String lastMessage;
  final DateTime dateLastMessage;
  final bool unread;
  final bool iaChat;
  Chat({
    required this.chatId,
    required this.userId,
    required this.nameUser,
    required this.lastName,
    required this.imgProfile,
    required this.lastMessage,
    required this.dateLastMessage,
    required this.unread,
    required this.iaChat,
  });
}
