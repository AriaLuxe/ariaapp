import 'package:ariapp/app/presentation/chats/chat/widgets/audio_message_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

class FavoritesMessageWidget extends StatelessWidget {
  final DateTime dateTime;
  final AudioPlayer audioPlayer;
  final String audioUrl;
  final bool? read;
  final bool? isMe;
  final Color color;

  const FavoritesMessageWidget({
    super.key,
    required this.dateTime,
    required this.read,
    required this.isMe,
    required this.audioPlayer,
    required this.audioUrl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      child: Column(
        children: [
          Container(
            child: _favoritesMessages(textTheme, dateTime),
          ),
        ],
      ),
    );
  }

  Widget _favoritesMessages(TextTheme textTheme, DateTime date) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                formattedDate,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ), //Contenedor del mensaje
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color, //Color(0xFF354271),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: _getMessageContent(),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8, left: 75, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  DateFormat('h:mm a').format(dateTime),
                  style: textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
                const SizedBox(width: 3),
              ],
            ),
          ),
          const Divider(color: Color(0xFF354271), thickness: 2),
        ],
      ),
    );
  }

  Widget _getMessageContent() {
    return AudioMessageContent(
      audioPlayer: audioPlayer,
      audioUrl: audioUrl,
    );
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
