class Chat {
  final int? chatId;
  final int userId;
  final String nameUser;
  final String lastName;
  final String imgProfile;
  final String? lastMessage;
  final DateTime? dateLastMessage;
  final bool? unread;
  final bool iaChat;
  final int? counterNewMessage;
  final int? durationSeconds;

  Chat({
    this.durationSeconds,
    this.counterNewMessage,
    this.chatId,
    required this.userId,
    required this.nameUser,
    required this.lastName,
    required this.imgProfile,
    this.lastMessage,
    this.dateLastMessage,
    this.unread,
    required this.iaChat,
  });
}
