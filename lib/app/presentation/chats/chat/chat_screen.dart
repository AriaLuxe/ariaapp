import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../security/user_logged.dart';
import 'bloc/chat_bloc.dart';
import 'widgets/audio_message.dart';
import 'widgets/audio_players.dart';
import 'widgets/audio_recorder.dart';


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
  const ChatScreen({Key? key, required this.chatId}) : super(key: key);
final int chatId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(),
      child:  Chat(chatId: chatId,),
    );
  }
}

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.chatId}) : super(key: key);
  final int chatId;
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _textController = TextEditingController();
  final userLogged = GetIt.instance<UserLogged>();
  late final String url;
  AudioPlayer audioPlayer = AudioPlayer();

  bool showPlayer = false;
  String? audioPath;

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.messageFetched(widget.chatId);
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
                        final isMe = message.sender == userLogged.userAria.id;
                        return AudioMessage(
                          audioPath: message.content,
                          time: DateTime.now(),
                          senderId: 1,
                          isMe: isMe,
                          url: 'https://uploadsaria.blob.core.windows.net/files/',
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: showPlayer
                      ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: AudioPlayers(
                      chatId: widget.chatId,
                      source: audioPath!,
                      onDelete: () {
                        setState(() => showPlayer = false);
                      },
                    ),
                  )
                      : AudioRecorder(
                    onStop: (path) {
                      if (kDebugMode) print('Recorded file path: $path');
                      setState(() {
                        audioPath = path;
                        showPlayer = true;
                      });
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
