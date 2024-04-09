import 'dart:typed_data';

import 'package:ariapp/app/presentation/chats/chat/bloc/chat_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'audio_message_content.dart';

class ChatMessageWidget extends StatelessWidget {
  final DateTime dateTime;
  final AudioPlayer audioPlayer;
  final String audioUrl;
  final String text;
  final bool? read;
  final bool? isMe;
  final Color color;
  final TypeMsg typeMsg;
  const ChatMessageWidget({
    super.key,
    required this.dateTime,
    required this.read,
    required this.isMe,
    required this.audioPlayer,
    required this.audioUrl,
    required this.color,
    required this.typeMsg,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      child: Column(
        children: [
          Container(
              child: isMe == true
                  ? _myMessage(textTheme, typeMsg)
                  : _notMyMessage(textTheme)),
        ],
      ),
    );
  }

  // Widget para mensajes del emisor actual (advisor)
  Widget _myMessage(TextTheme textTheme, TypeMsg typeMsg) {
    final MessageStatusInfo statusInfo = getStatusInfo(read!);
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //Contenedor del mensaje
          Container(
            padding: const EdgeInsets.all(9),
            margin: const EdgeInsets.only(bottom: 5, left: 55, right: 10),
            decoration: BoxDecoration(
              color: color, //Color(0xFF354271),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: _getMessageContent(typeMsg),
          ),
          // Contenedor de la hora del mensaje
          Container(
            margin: const EdgeInsets.only(bottom: 8, left: 55, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateFormat('h:mm a')
                      .format(dateTime.subtract(const Duration(hours: 5))),
                  style: textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
                const SizedBox(width: 3),
                Icon(
                  statusInfo.iconData,
                  size: 15,
                  color: statusInfo.iconColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para mensajes del receptor
  Widget _notMyMessage(TextTheme textTheme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Contenedor del mensaje
          Container(
            padding: const EdgeInsets.all(9),
            margin: const EdgeInsets.only(bottom: 5, left: 10, right: 55),
            decoration: const BoxDecoration(
              color: Color(0xFF354271),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: _getMessageContent(typeMsg),
          ),
          // Contenedor de la hora del mensaje
          Container(
            margin: const EdgeInsets.only(bottom: 8, left: 15, right: 50),
            child: Text(
              DateFormat('h:mm a')
                  .format(dateTime.subtract(const Duration(hours: 5))),
              style: textTheme.bodySmall?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getMessageContent(TypeMsg typeMsg) {
    if (typeMsg == TypeMsg.audio) {
      return AudioMessageContent(
        audioPlayer: audioPlayer,
        audioUrl: audioUrl,
      );
    } else {
      return Text(
        text,
        style: const TextStyle(color: Colors.white),
      );
    }
  }
}

MessageStatusInfo getStatusInfo(bool status) {
  Color iconColor;
  IconData iconData;

  switch (status) {
    case false:
      iconColor = Colors.grey;
      iconData = Icons.check_circle;
      break;
    case true:
      iconColor = const Color(0xFF5368d6);
      iconData = Icons.check_circle;
      break;

    default:
      iconColor = Colors.grey;
      iconData = Icons.check_circle;
  }

  return MessageStatusInfo(iconColor, iconData);
}

class MessageStatusInfo {
  final Color iconColor;
  final IconData iconData;

  MessageStatusInfo(this.iconColor, this.iconData);
}
