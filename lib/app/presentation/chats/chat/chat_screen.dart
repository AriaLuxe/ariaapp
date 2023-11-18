import 'package:ariapp/app/presentation/chats/chat/widgets/audio_player_widget.dart';
import 'package:ariapp/app/presentation/widgets/header.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../widgets/header_chat.dart';
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
    return Chat(chatId: chatId,);
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
  //final userLogged = GetIt.instance<UserLogged>();

  late final String url;
  AudioPlayer audioPlayer = AudioPlayer();

  bool showPlayer = false;
  String? audioPath;
  int? userId;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    showPlayer = false;
   // userId =  SharedPreferencesManager.getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    //chatBloc.messageFetched(widget.chatId);
    return Scaffold(

      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state.chatStatus == ChatStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.chatStatus == ChatStatus.error) {
            return const Center(child: Text('Error fetching messages'));
          } else {
            final messages = state.messages;
            //var messagesOrder = messages.reversed.toList();
            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width*0.9,
                      child: HeaderChat(title: 'asd', onTap: (){
                        Navigator.pop(context);
                      }, url: 'https://th.bing.com/th/id/R.749ef6ba37425e40d6b8ffb16f2ea08e?rik=OHNHPvVuuCHGsA&pid=ImgRaw&r=0',)),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: Color(0xFF354271),

                      thickness: 2
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index)  {
//                          final message = messages[messages.length-1- index];
                          final message = messages.toList();


                          return message[index];
                        },
                      ),
                    ),
                  ),
                  const SizedBox(),
                  AudioRecorder(
                    iconSize: 25,
                    onStop: (path) {
                      print('Audio grabado');
                      if (kDebugMode) print('Ruta del archivo grabado: $path');
                      audioPath = path;
                      chatBloc.isRecording(true);
                      if (audioPath != null) {

                        print('Audio enviado');
                        print(audioPath);
                        chatBloc.messageSent(widget.chatId, audioPath!);
                        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                        chatBloc.isRecording(false);
                      } else {
                        print('No hay audio para enviar');
                      }
                      // showPlayer = true;
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
