import 'dart:convert';

import '../../domain/entities/chat.dart';

import 'package:ariapp/app/domain/entities/user_aria.dart';

class ChatModel extends Chat {
  ChatModel({
    required int id,
    required int userId,
    required UserAria receptor,
    required String time,
    required String text,
    required bool isLiked,
    required bool unread,
  }) : super(
          id: id,
          userId: userId,
          receptor: receptor,
          time: time,
          text: text,
          isLiked: isLiked,
          unread: unread,
        );
  factory ChatModel.fromMap(Map json) {
    return ChatModel(
      id: json['id'],
      userId: json['userId'],
      receptor: json['receptor'],
      time: json['time'],
      text: json['text'],
      isLiked: json['isLiked'],
      unread: json['unread'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'receptorId': receptor,
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
