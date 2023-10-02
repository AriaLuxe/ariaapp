import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/styles.dart';
import '../chat/chat_screen.dart';
import 'bloc/chat_list_bloc.dart';

class ChatsList extends StatelessWidget {
  const ChatsList({super.key});

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = remainingSeconds.toString().padLeft(2, '0');
    print(minutesStr);
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
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
                    'Aún no hay chats',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              );
            } else {
              return Expanded(
                child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: state.chats.length,
                      itemBuilder: (context, index) {
                        final chat = state.chats[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  ChatScreen(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 0.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: chat.unread ?? false
                                        ? const Color(0xffF5F5FF)
                                        : Colors.white,
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
                                              radius: 35.0,
                                              backgroundImage: AssetImage(
                                                'assets/images/${index + 1}.jpg',
                                              ),
                                            ),
                                            const SizedBox(width: 10.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${chat.nameUser} ${chat.lastName}',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 5.0),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.mic_rounded,
                                                      color: chat.unread ??
                                                              false
                                                          ? Colors.grey
                                                          : Styles.primaryColor,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                      child: Text(
                                                        formatDuration(
                                                            chat.durationSeconds ??
                                                                0),
                                                        style: const TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        overflow: TextOverflow
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
                                              '${chat.dateLastMessage?.hour}:${chat.dateLastMessage?.minute}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            chat.unread ?? false
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        chat.counterNewMessage
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
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
                        );
                      },
                    )),
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
