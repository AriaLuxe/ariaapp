class Message {
  final int id;
  final int sender;
  final String content;
  final int durationSeconds;
  final DateTime date;
  final bool read;
  final bool isLiked;
  final int chat;

  Message( {
    required this.durationSeconds,
    required this.id,
    required this.sender,
    required this.content,
    required this.date,
    required this.read,
    required this.isLiked,
    required this.chat,
  });
}
