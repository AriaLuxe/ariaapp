import 'dart:convert';

import '../../domain/entities/chat.dart';

import 'package:ariapp/app/domain/entities/user_aria.dart';

class ChatModel extends Chat {
  ChatModel({
    required int id,
    required int userId,
    required UserAria receptor,
    required DateTime date,
    required String lastMessage,
    required bool unread,
  }) : super(
          id: id,
          userId: userId,
          receptor: receptor,
          date: date,
          lastMessage: lastMessage,
          unread: unread,
        );
  factory ChatModel.fromMap(Map json) {
    return ChatModel(
      id: json['id'],
      userId: json['userId'],
      receptor: json['receptor'],
      date: json['date'],
      lastMessage: json['lastMessage'],
      unread: json['unread'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'receptorId': receptor,
      'date': date,
      'lastMessage': lastMessage,
      'unread': unread,
    };
  }

  static List<ChatModel> toChatsList(String str) {
    return List<ChatModel>.from(
        jsonDecode(str).map((x) => ChatModel.fromMap(x)));
  }
}
