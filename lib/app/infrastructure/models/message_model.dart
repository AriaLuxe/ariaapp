import 'dart:convert';

import '../../domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required int id,
    required int sender,
    required String content,
     required int durationSeconds,
    required DateTime date,
    required bool unread,
    required bool isLiked,
    required int chat,
  }) : super(
          id: id,
          sender: sender,
          content: content,
          durationSeconds: durationSeconds,
          date: date,
          unread: unread,
          isLiked: isLiked,
          chat: chat,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? 0,
      sender: json['sender'] ?? 0,
      content: json['content'] ?? '',
      durationSeconds: json['durationSeconds'] ?? 0,
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      unread: json['unread'] ??
          true, // Asumiendo que los mensajes sin leer son true por defecto
      isLiked: json['isliked'] ?? false,
      chat: json['chat'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'content': content,
      'durationSeconds': durationSeconds,
      'date': date.toIso8601String(),
      'unread': unread,
      'isliked': isLiked,
      'chat': chat,
    };
  }

  static List<MessageModel> fromJsonList(String str) {
    final List<dynamic> parsedJson = jsonDecode(str);
    return parsedJson.map((json) => MessageModel.fromJson(json)).toList();
  }

}
