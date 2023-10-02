import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../../../security/user_logged.dart';
import 'bloc/chat_bloc.dart';
import 'widgets/message.dart';

class PositionData {
  const PositionData(
      this.position,
      this.bufferedPosition,
      this.duration,
      );
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(),
      child: const Chat(),
    );
  }
}

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _textController = TextEditingController();
  final userLogged = GetIt.instance<UserLogged>();
  late final AudioPlayer audioPlayer;
  late final String url;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    url = 'https://uploadsaria.blob.core.windows.net/files/';
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    audioPlayer.dispose(); // Liberar recursos del AudioPlayer
    super.dispose();
  }

  Widget _buildMessage(String audioPath, DateTime time, int senderId) {
    final isMe = senderId == userLogged.userAria.id;
    final audioUrl = '$url$audioPath';

    Stream<PositionData> positionDataStream = Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      audioPlayer.positionStream,
      audioPlayer.bufferedPositionStream,
      audioPlayer.durationStream,
          (position, bufferedPosition, duration) {
        final validDuration = duration ?? Duration.zero;
        return PositionData(position, bufferedPosition, validDuration);
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: isMe
            ? const EdgeInsets.only(top: 8, bottom: 8, left: 80)
            : const EdgeInsets.only(top: 8, bottom: 8, right: 80),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF202248) : const Color(0xffF5F5FF),
          borderRadius: isMe
              ? const BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )
              : const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: StreamBuilder<PlayerState?>(
                    stream: audioPlayer.playerStateStream,
                    builder: (_, snapshot) {
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing;
                      if (!(playing ?? false)) {
                        return IconButton(
                          onPressed: () async {
                            if (audioPlayer.playing) {
                              await audioPlayer.pause();
                            } else {
                              await audioPlayer.setUrl(audioUrl);
                              await audioPlayer.play();
                            }
                          },
                          icon: const Icon(Icons.play_arrow_rounded),
                        );
                      } else if (processingState != ProcessingState.completed) {
                        return IconButton(
                          onPressed: () async {
                            await audioPlayer.pause();
                          },
                          icon: const Icon(Icons.pause_rounded),
                        );
                      }
                      return const Icon(
                        Icons.play_arrow_rounded,
                        size: 40,
                        color: Colors.yellow,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<PositionData>(
                    stream: positionDataStream,
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return const LinearProgressIndicator();
                      }

                      final positionData = snapshot.data!;
                      final durationMilliseconds = positionData.duration.inMilliseconds;
                      final positionMilliseconds = positionData.position.inMilliseconds;

                      if (durationMilliseconds == 0) {
                        return const LinearProgressIndicator(value: 0.0);
                      }

                      double progressValue = positionMilliseconds / durationMilliseconds;

                      return LinearProgressIndicator(
                        value: progressValue,
                        color: isMe ? Theme.of(context).primaryColor : Colors.white,
                        backgroundColor: isMe ? Colors.white : Theme.of(context).primaryColor,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${time.hour}:${time.minute}',
              style: TextStyle(
                color: isMe ? Colors.white : const Color(0xFF202248),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageComposer(ChatBloc chatBloc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.photo),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              // Implement logic to send photos.
            },
          ),
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return TextField(
                  controller: _textController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Send a message...',
                  ),
                  onSubmitted: (message) {
                    //chatBloc.add(MessageSent(message)); // Descomentar para enviar mensajes
                    _textController.clear();
                  },
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              final message = _textController.text;
              if (message.isNotEmpty) {
                //chatBloc.add(MessageSent(message)); // Descomentar para enviar mensajes
                _textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.messageFetched(1);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Title'),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state.chatStatus == ChatStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.chatStatus == ChatStatus.error) {
            return const Center(child: Text('Error fetching messages'));
          } else {
            final messages = state.messages;
            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return _buildMessage(
                          message.content,
                          message.date,
                          message.sender,
                        );
                      },
                    ),
                  ),
                ),
                _buildMessageComposer(chatBloc),
              ],
            );
          }
        },
      ),
    );
  }
}
