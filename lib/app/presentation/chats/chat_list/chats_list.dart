import 'package:ariapp/app/presentation/chats/chat/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/styles.dart';
import 'bloc/chat_list_bloc.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key});

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  Future<void> refresh() async {
    final chatListBloc = BlocProvider.of<ChatListBloc>(context);
    chatListBloc.chatsFetched();
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    final chatListBloc = BlocProvider.of<ChatListBloc>(context);

    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) {
        switch (state.chatListStatus) {
          case ChatListStatus.error:
            return const Expanded(
              child: Center(
                child: Text(
                  'error al cargar elementos',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          case ChatListStatus.loading:
            return const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case ChatListStatus.initial:
            return const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case ChatListStatus.success:
            if (state.chats.isEmpty) {
              return const Expanded(
                child: Center(
                  child: Text(
                    'No tienes chats',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                ),
              );
            } else {
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (_) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: RefreshIndicator(
                    onRefresh: refresh,
                    child: ListView.builder(
                      itemCount: state.chats.length,
                      itemBuilder: (context, index) {
                        final chat = state.chats[index];
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (BuildContext context) {
                                  chatListBloc.deleteChat(chat.chatId!);
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete_outline,
                                label: 'Borrar',
                              ),
                            ],
                          ),
                          key: UniqueKey(),
                          child: GestureDetector(
                            onTap: () {
                              chatBloc.dataChatFetched(chat.userId);
                              chatBloc.messageFetched(chat.chatId!, 0, 12);
                              context.push(
                                  '/chat/${chat.chatId}/${chat.chatId!}/${chat.userId}');
                            },
                            child: Padding(
                              padding: chat.unread ?? true
                                  ? const EdgeInsets.only(right: 12.0)
                                  : const EdgeInsets.only(top: 0.0),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 0.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: chat.unread ?? true
                                            ? const BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20),
                                              )
                                            : const BorderRadius.only(
                                                topLeft: Radius.circular(40),
                                                topRight: Radius.circular(40),
                                                bottomRight:
                                                    Radius.circular(40),
                                              ),
                                        color: chat.unread ?? false
                                            ? const Color(0xff354271)
                                            : Styles.primaryColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 30.0,
                                                  backgroundImage: NetworkImage(
                                                    'https://uploadsaria.blob.core.windows.net/files/${chat.imgProfile}',
                                                  ),
                                                ),
                                                const SizedBox(width: 10.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      child: Text(
                                                        '${chat.nameUser} ${chat.lastName}',
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: Colors.white,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5.0),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.mic_rounded,
                                                          color: Colors.grey,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                          child: Text(
                                                            formatDuration(
                                                                chat.durationSeconds ??
                                                                    0),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  DateFormat.jm().format(chat
                                                      .dateLastMessage!
                                                      .subtract(const Duration(
                                                          hours: 5))),
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                chat.unread ?? false
                                                    ? const CircleAvatar(
                                                        radius: 8,
                                                        backgroundColor:
                                                            Color(0xFF5368d6),
                                                      )
                                                    : const Text(''),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }
          default:
            return const Center(
              child: Text('Comuníquese cal email@gmail.com'),
            );
        }
      },
    );
  }
}
