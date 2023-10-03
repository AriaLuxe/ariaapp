class Message {
  final int id;
  final int sender;
  final String content;
  final int durationSeconds;

  final DateTime date;
  final bool unread;
  final bool isLiked;
  final int chat;

  Message( {
    required this.durationSeconds,
    required this.id,
    required this.sender,
    required this.content,
    required this.date,
    required this.unread,
    required this.isLiked,
    required this.chat,
  });
}

