import 'dart:convert';

import 'package:ariapp/app/infrastructure/models/user_aria_model.dart';

import '../../domain/entities/chat.dart';

class ChatModel extends Chat {
  ChatModel({
    required int id,
    required int userId,
    required UserAriaModel receptor,
    required String date,
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
  factory ChatModel.fromMap(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      userId: json['userId'],
      receptor: UserAriaModel.fromJson(json['receptor']),
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
