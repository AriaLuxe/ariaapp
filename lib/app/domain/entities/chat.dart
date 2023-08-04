import 'package:ariapp/app/domain/entities/user_aria.dart';

class Chat {
  final int id;
  final int userId;
  final UserAria receptor;
  final String date;
  final String lastMessage;
  final bool unread;
  Chat({
    required this.id,
    required this.userId,
    required this.receptor,
    required this.date,
    required this.lastMessage,
    required this.unread,
  });
}
