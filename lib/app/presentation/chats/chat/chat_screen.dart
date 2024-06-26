import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:ariapp/app/config/base_url_config.dart';
import 'package:ariapp/app/infrastructure/repositories/message_repository.dart';
import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/presentation/chats/chat_list/bloc/chat_list_bloc.dart';
import 'package:ariapp/app/presentation/profiles/profile/profile_screen.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

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
  const ChatScreen(
      {Key? key,
      required this.userId,
      required this.chatId,
      required this.userReceivedId})
      : super(key: key);
  final int userId;
  final int chatId;
  final int userReceivedId;

  @override
  Widget build(BuildContext context) {
    return Chat(
      userId: userId,
      chatId: chatId,
      userReceivedId: userReceivedId,
    );
  }
}

class Chat extends StatefulWidget {
  const Chat(
      {Key? key,
      required this.userId,
      required this.chatId,
      required this.userReceivedId})
      : super(key: key);
  final int userId;
  final int chatId;
  final int userReceivedId;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late final String url;
  int page = 0;
  bool showPlayer = false;
  String? audioPath;
  int? userId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    showPlayer = false;
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.checkBlock(widget.userReceivedId);
    chatBloc.checkBlockMeYou(widget.userReceivedId);

    chatBloc.checkCreator(widget.userReceivedId);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        page++;
        chatBloc.loadMoreMessages(
          widget.chatId,
          page,
          12,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    final chatListBloc = BlocProvider.of<ChatListBloc>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final messages = state.messages;
          if (state.chatStatus == ChatStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.chatStatus == ChatStatus.error) {
            return const Center(child: Text('Error fetching messages'));
          } else if (state.chatStatus == ChatStatus.success) {
            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: size.width * 0.9,
                      child: HeaderChat(
                        title: state.name,
                        onTap: () {
                          chatBloc.clearMessages();
                          Navigator.pop(context);
                        },
                        url: '${BaseUrlConfig.baseUrlImage}${state.urlPhoto}',
                        onTapProfile: () async {
                          final userAriaRepository =
                              GetIt.instance<UserAriaRepository>();
                          final user = await userAriaRepository
                              .getUserById(state.userId);
                          if (user.enabled!) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileScreen(user: user)));
                          }
                        },
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(color: Color(0xFF354271), thickness: 2),
                  state.messages.isEmpty
                      ? const Expanded(
                          child: Center(
                              child: Text(
                          'Manda tu primer mensaje',
                          style: TextStyle(color: Colors.white),
                        )))
                      : Expanded(
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
                                itemCount: messages.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < messages.length) {
                                    final message = messages.toList();
                                    return GestureDetector(
                                        onLongPressStart:
                                            (longPressStartDetails) {
                                          final RenderBox overlay =
                                              Overlay.of(context)
                                                      .context
                                                      .findRenderObject()
                                                  as RenderBox;
                                          final tapPosition =
                                              overlay.globalToLocal(
                                                  longPressStartDetails
                                                      .globalPosition);
                                          _showPopupMenu(
                                              context,
                                              tapPosition,
                                              state.messagesData[index].id,
                                              index,
                                              state
                                                  .messagesData[index].isLiked);
                                        },
                                        child: message[index]);
                                  } else {
                                    return Visibility(
                                      visible: !(messages.length < 8),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: state.hasMoreMessages
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : Flash(
                                                  child: const Center(
                                                      child: Text(
                                                  'No hay mas mensajes',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                )))),
                                    );
                                  }
                                }),
                          ),
                        ),
                  const SizedBox(),
                  state.recordingResponse
                      ? const LinearProgressIndicator()
                      : const SizedBox(),
                  state.isCreator
                      ? !state.meBlockYou
                          ? state.isBlock
                              ? showStatusUserWidget(
                                  'El usuario\nte ha bloqueado')
                              : AudioRecorderView(
                                  onSaved: (path) async {
                                    if (kDebugMode) {
                                      log('path of archive record: $path');
                                    }
                                    audioPath = path;
                                    chatBloc.isRecording(true);
                                    if (audioPath != null) {
                                      chatBloc.messageSent(
                                        widget.chatId,
                                        widget.userReceivedId,
                                        audioPath!,
                                        '',
                                        TypeMsg.audio,
                                      );
                                      chatBloc.isRecording(false);
                                      final AudioPlayer audioPlayerNotify =
                                          AudioPlayer();
                                      audioPlayerNotify
                                          .setAsset('assets/audio/Eureka.mp3');
                                      audioPlayerNotify.play();
                                      await Future.delayed(
                                          const Duration(milliseconds: 5000));
                                      chatListBloc.chatsFetched();
                                    } else {
                                      log('No hay audio para enviar');
                                    }
                                    // showPlayer = true;
                                  },
                                  chatId: widget.chatId,
                                  userReceivedId: widget.userReceivedId,
                                )
                          : showStatusUserWidget('Desbloquea usuario')
                      : showStatusUserWidget('El usuario ya no\nes creador'),
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

  void _showPopupMenu(BuildContext context, Offset tapPosition, int messageId,
      int index, bool isFavorite) async {
    bool tempIsFavorite = isFavorite;

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        tapPosition,
        tapPosition,
      ),
      Offset.zero & overlay.size,
    );

    await showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.0),
      ),
      color: Colors.white.withOpacity(0.48),
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF354271).withOpacity(0.97),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ListTile(
              title: const Text('Favoritos  ',
                  style: TextStyle(color: Colors.green)),
              trailing: Icon(
                  tempIsFavorite ? Icons.bookmark_remove : Icons.bookmark_add,
                  color: Colors.green),
              onTap: () {
                final messageRepository = GetIt.instance<MessageRepository>();
                messageRepository.likedMessage(messageId);
                setState(() {
                  tempIsFavorite = !tempIsFavorite;
                });
                Navigator.pop(context);
              },
            ),
          ),
        ),
        PopupMenuItem(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF354271).withOpacity(0.97),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListTile(
                title:
                    const Text('Eliminar', style: TextStyle(color: Colors.red)),
                trailing: const Icon(Icons.delete, color: Colors.red),
                onTap: () async {
                  final chatBloc = BlocProvider.of<ChatBloc>(context);
                  chatBloc.deleteMessage(messageId, index);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget showStatusUserWidget(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const IconButton(
            icon: Icon(Icons.backspace, color: Colors.grey),
            onPressed: null,
          ),
          Container(
            decoration: BoxDecoration(
                color: const Color(0xFFaaaaaa),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const IconButton(
            icon: Icon(Icons.send, color: Colors.grey),
            onPressed: null,
          )
        ],
      ),
    );
  }
}
