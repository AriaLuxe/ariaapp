import 'dart:convert';

import 'package:ariapp/app/domain/entities/chat.dart';

class ChatModel extends Chat {
  ChatModel({
    required int chatId,
    required int userId,
    required String nameUser,
    required String lastName,
    required String imgProfile,
    required String lastMessage,
    required DateTime dateLastMessage,
    required bool unread,
    required bool iaChat,
  }) : super(
          chatId: chatId,
          userId: userId,
          nameUser: nameUser,
          lastName: lastName,
          imgProfile: imgProfile,
          lastMessage: lastMessage,
          dateLastMessage: dateLastMessage,
          unread: unread,
          iaChat: iaChat,
        );

  factory ChatModel.fromMap(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chatId'],
      userId: json['userId'],
      nameUser: json['nameUser'],
      lastName: json['lastName'],
      imgProfile: json['imgProfile'],
      lastMessage: json['lastMessage'],
      dateLastMessage: DateTime.parse(
          json['dateLastMessage']), // Conversión manual si es necesario
      unread: json['unread'],
      iaChat: json['iaChat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'userId': userId,
      'nameUser': nameUser,
      'lastName': lastName,
      'imgProfile': imgProfile,
      'lastMessage': lastMessage,
      'dateLastMessage':
          dateLastMessage.toIso8601String(), // Conversión a ISO 8601
      'unread': unread,
      'iaChat': iaChat,
    };
  }

  static List<ChatModel> toChatsList(String str) {
    return List<ChatModel>.from(
        jsonDecode(str).map((x) => ChatModel.fromMap(x)));
  }
}
