import 'package:animate_do/animate_do.dart';
import 'package:ariapp/app/config/base_url_config.dart';
import 'package:ariapp/app/presentation/chats/chat_list/bloc/chat_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../widgets/header_chat.dart';
import 'bloc/chat_bloc.dart';
import 'widgets/audio_recorder_voice.dart';


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
  const ChatScreen({Key? key, required this.userId, required this.chatId, required this.userReceivedId}) : super(key: key);
final int userId;
final int chatId;
final int userReceivedId;
  @override
  Widget build(BuildContext context) {
    return Chat(userId: userId, chatId: chatId, userReceivedId: userReceivedId,);
  }
}

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.userId, required this.chatId, required this.userReceivedId}) : super(key: key);
  final int userId;
  final int chatId;
  final int userReceivedId;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _textController = TextEditingController();
  //final userLogged = GetIt.instance<UserLogged>();

  late final String url;
  int page =0;
  bool showPlayer = false;
  String? audioPath;
  int? userId;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    showPlayer = false;
   // userId =  SharedPreferencesManager.getUserId();
    final chatBloc = BlocProvider.of<ChatBloc>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        page++;
        chatBloc.loadMoreMessages(
          widget.chatId,
          page,
          8,
        );
        print(page);


      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final chatBloc = BlocProvider.of<ChatBloc>(context);
    final chatListBloc = BlocProvider.of<ChatListBloc>(context);


    return Scaffold(

      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final messages = state.messages;
          if (state.chatStatus == ChatStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.chatStatus == ChatStatus.error) {
            return const Center(child: Text('Error fetching messages'));
          } else if (state.chatStatus == ChatStatus.success) {
            //var messagesOrder = messages.reversed.toList();
            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width*0.9,
                      child: HeaderChat(title: state.name, onTap: (){
                        chatBloc.clearMessages();
                        Navigator.pop(context);
                      }, url: '${BaseUrlConfig.baseUrlImage}${state.urlPhoto}',)),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                      color: Color(0xFF354271),

                      thickness: 2
                  ),
                  state.messages.isEmpty ?
               const Expanded(child: Center(child: Text('Manda tu primer mensaje',style: TextStyle(color: Colors.white),)))
              :Expanded(
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
                        itemCount: messages.length+1,
                        itemBuilder: (context, index) {
                          if (index < messages.length) {
                            final message = messages.toList();
                            return message[index];
                          } else {
                            return  Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: state.hasMoreMessages ? const Center(child: CircularProgressIndicator()): Flash(child: const Center(child:  Text('No hay mas mensajes',style: TextStyle(color: Colors.grey),)))
                            );
                          }
                        }
                      ),
                    ),
                  ),
                  const SizedBox(),
                  state.recordingResponse? const LinearProgressIndicator(): const SizedBox(),
                  AudioRecorderView(
                    onSaved: (path) async {
                      print('Audio grabado');
                      if (kDebugMode) print('Ruta del archivo grabado: $path');
                      audioPath = path;
                      chatBloc.isRecording(true);
                      if (audioPath != null) {
                        print('Audio enviado');
                         chatBloc.messageSent(widget.chatId, widget.userReceivedId, audioPath!,);
                        chatBloc.isRecording(false);
                        await Future.delayed(const Duration(milliseconds: 5000));
                        chatListBloc.chatsFetched();

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
          return const Center(
            child: Text('Comuníquese al email@gmail.com'),
          );

        },

      ),
    );
  }
}
