//import 'package:ariapp/app/domain/models/user_aria_model.dart';
import 'package:ariapp/app/domain/entities/user_aria.dart';

class Message {
  final UserAria receptor;
  final DateTime date;
  final String message;
  final bool isLiked;
  final bool unread;

  Message({
    required this.receptor,
    required this.date,
    required this.message,
    required this.isLiked,
    required this.unread,
  });
}


/*List<Message> chats = [
  Message(
    sender: isabellaSermon,
    time: '5:30 PM',
    text: 'Hey, how are  you, how was your day?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: lyangLo,
    time: '5:30 PM',
    text: 'Hey, how are  you, how was your day?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: coco,
    time: '1:24 PM',
    text: 'Hey, how are  you, how was your day?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: becky,
    time: '5:30 PM',
    text: 'Hey, how are  you, how was your day?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: analu,
    time: '5:30 PM',
    text: 'Hey, how are  you, how was your day?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: anaCloud,
    time: '5:30 PM',
    text: 'Hey, how are  you, how was your day?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: anaCloud,
    time: '5:30 PM',
    text: 'Hey, how are  you, how was your day?',
    isLiked: false,
    unread: true,
  ),
];

List<Message> messages = [
  Message(
    sender: isabellaSermon,
    time: '5:30 PM',
    text: 'Hey, how are  you, how was your day?',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '5:30 PM',
    text: 'Hey, how are  you, how was your day?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: isabellaSermon,
    time: '5:30 PM',
    text: 'Hey, how are  you, how was your day?',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '5:30 PM',
    text: 'Hey, how are  you, how was your day?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: isabellaSermon,
    time: '5:30 PM',
    text: 'Hey, how are  you, how was your day?',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '5:30 PM',
    text: 'Hey, how are  you, how was your day?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: isabellaSermon,
    time: '5:30 PM',
    text: 'Hey, how are  you, how was your day?',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '5:30 PM',
    text: 'Hey, how are  you, how was your day?',
    isLiked: false,
    unread: true,
  ),
];
*/