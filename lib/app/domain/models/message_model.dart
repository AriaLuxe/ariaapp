//import 'package:ariapp/app/domain/models/user_aria_model.dart';
import 'package:ariapp/app/domain/models/user_model.dart';

class Message {
  //final int id;
  final User sender;
  final String time;
  final String text;
  //final String content;
  final bool isLiked;
  final bool unread;

  Message({
    //required this.id,
    required this.sender,
    required this.time,
    required this.text,
    //required this.content,
    required this.isLiked,
    required this.unread,
  });
/*
  factory Message.fromMap(Map messageMap) {
    return Message(
      id: messageMap['id'],
      sender: messageMap['sender'],
      time: messageMap['time'],
      text: messageMap['text'],
      isLiked: messageMap['isLiked'],
      content: messageMap['content'],
      unread: messageMap['unread'],
    );
  }*/
}

final User currentUser = User(
  id: 0,
  name: "Current user",
  imageUrl: 'assets/images/pppp.jpg',
);

final User emmaWatson = User(
  id: 1,
  name: "Emma Watson",
  imageUrl: 'assets/images/1.jpg',
);

final User isabellaSermon = User(
  id: 2,
  name: "Isabella Sermon",
  imageUrl: 'assets/images/issy.jpg',
);

final User annaRobb = User(
  id: 3,
  name: "Anna Sophia Robb",
  imageUrl: 'assets/images/s1.png',
);

final User anaCloud = User(
  id: 4,
  name: "Ana Cloud",
  imageUrl: 'assets/images/2.png',
);

final User becky = User(
  id: 5,
  name: "Becky Espinoza",
  imageUrl: 'assets/images/s4.png',
);

final User analu = User(
  id: 6,
  name: "Analu Mansilla",
  imageUrl: 'assets/images/s2.png',
);

final User lyangLo = User(
  id: 7,
  name: "Lyang Lo",
  imageUrl: 'assets/images/s3.png',
);

final User coco = User(
  id: 8,
  name: "Coco Conosce",
  imageUrl: 'assets/images/future.jpeg',
);

//favorite contacts
List<User> favorites = [coco, lyangLo, isabellaSermon, becky, emmaWatson];

List<Message> chats = [
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
