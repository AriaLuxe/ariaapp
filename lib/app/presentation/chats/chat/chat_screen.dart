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

  ScrollController _scrollController = ScrollController();

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
            //var messagesOrder = messages.reversed.toList();
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
                      reverse: true,
                      controller: _scrollController, // Asigna el controlador al ListView
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[messages.length-1- index];
                        print(message.id);
                        final isMe = message.sender == userLogged.userAria.id;
                        return AudioMessage(
                          audioPath: message.content,
                          time: message.date,
                          senderId: 1,
                          isMe: isMe,
                          url: 'https://uploadsaria.blob.core.windows.net/files/',
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: state.isRecording
                      ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: AudioPlayers(
                      onSent: (){
                        print('aaa');                        print(audioPath!);
                        chatBloc.messageSent(widget.chatId,audioPath!);
                        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                        chatBloc.isRecording(false);

                      },
                      //chatId: widget.chatId,
                      source: audioPath!,
                      onDelete: () {
                      //showPlayer = false;
                      chatBloc.isRecording(false);

                      },
                    ),
                  )
                      : AudioRecorder(iconSize: 30,
                    onStop: (path) {
                      print('path enviado');
                      print(path);
                      if (kDebugMode) print('Recorded file path: $path');
                        audioPath = path;

                      chatBloc.isRecording(true);

                      //showPlayer = true;
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
