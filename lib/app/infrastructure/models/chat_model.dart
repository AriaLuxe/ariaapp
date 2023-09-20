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
    required int durationSeconds,
    required int counterNewMessage,
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
          durationSeconds: durationSeconds,
          counterNewMessage: counterNewMessage,
        );

  factory ChatModel.fromMap(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['idChat'] ?? 0, // Valor predeterminado para chatId
      userId: json['userId'] ?? 0, // Valor predeterminado para userId
      nameUser: json['nameUser'] ?? '', // Valor predeterminado para nameUser
      lastName: json['lastName'] ?? '', // Valor predeterminado para lastName
      imgProfile:
          json['imgProfile'] ?? '', // Valor predeterminado para imgProfile
      lastMessage:
          json['lastMessage'] ?? '', // Valor predeterminado para lastMessage
      dateLastMessage: json['dateLastMessage'] != null
          ? DateTime.parse(json['dateLastMessage'])
          : DateTime.now(), // Fecha actual como valor predeterminado
      unread: json['unread'] ?? false, // Valor predeterminado para unread
      iaChat: json['iaChat'] ?? false, // Valor predeterminado para iaChat

      durationSeconds: json['durationSeconds'] ?? 0,
      counterNewMessage: json['durationSeconds'] ??
          0, // Valor predeterminado para durationSeconds
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idChat': chatId,
      'idUser': userId,
      'nameUser': nameUser,
      'lastName': lastName,
      'imgProfile': imgProfile,
      'lastMessage': lastMessage,
      'dateLastMessage': dateLastMessage?.toIso8601String(),
      'unread': unread,
      'iaChat': iaChat,
      'durationSeconds': durationSeconds,
      'counterMessage': counterNewMessage
    };
  }

  static List<ChatModel> toChatsList(String str) {
    return List<ChatModel>.from(
        jsonDecode(str).map((x) => ChatModel.fromMap(x)));
  }
}
