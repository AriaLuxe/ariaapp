import 'package:ariapp/app/domain/entities/user_aria.dart';

class Chat {
  final int id;
  final int userId;
  final UserAria receptor;
  final String time;
  final String text;
  final bool isLiked;
  final bool unread;
  Chat({
    required this.id,
    required this.userId,
    required this.receptor,
    required this.time,
    required this.text,
    required this.isLiked,
    required this.unread,
  });
}
