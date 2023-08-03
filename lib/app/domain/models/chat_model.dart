import 'dart:convert';

import 'package:ariapp/app/domain/models/user_aria_model.dart';

class Chat {
  final int id;
  final List<UserAria> users;

  Chat({
    required this.id,
    required this.users,
  });

  factory Chat.fromMap(Map chatMap) {
    return Chat(
      id: chatMap['id'],
      users: chatMap['users'],
    );
  }
}

class ChatModel {
  final int userId;
  final String name;
  final int receptorId;
  final String time;
  final String text;
  final bool isLiked;
  final bool unread;

  ChatModel({
    required this.userId,
    required this.name,
    required this.receptorId,
    required this.time,
    required this.text,
    required this.isLiked,
    required this.unread,
  });

  factory ChatModel.fromMap(Map chatMap) {
    return ChatModel(
      userId: chatMap['userId'],
      name: chatMap['name'],
      receptorId: chatMap['receptorId'],
      time: chatMap['time'],
      text: chatMap['text'],
      isLiked: chatMap['isLiked'],
      unread: chatMap['unread'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'receptorId': receptorId,
      'time': time,
      'text': text,
      'isLiked': isLiked,
      'unread': unread,
    };
  }

  static List<ChatModel> toChatsList(String str) {
    return List<ChatModel>.from(
        jsonDecode(str).map((x) => ChatModel.fromMap(x)));
  }
}
