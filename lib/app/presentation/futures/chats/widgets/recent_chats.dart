import 'package:ariapp/app/infrastructure/data_sources/chats_data_provider.dart';
import 'package:flutter/material.dart';

import '../../../../infrastructure/models/chat_model.dart';

class RecentChats extends StatelessWidget {
  RecentChats({super.key});

  final chatsDataProvider = ChatsDataProvider();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 300.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: FutureBuilder(
              future: chatsDataProvider.getAllChatsByUserId(1),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  final chats1 = snapshot.data!;

                  return ListView.builder(
                    itemCount: chats1.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ChatModel chat = chats1[index];

                      return GestureDetector(
                        // onTap: () =>// Navigator.push(
                        // context,
                        //MaterialPageRoute(
                        //builder: (_) => ChatScreen(user: chat.sender),
                        //),
                        // ),
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 5.0, bottom: 5.0, right: 20.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: chat.unread
                                ? const Color(0xffF5F5FF)
                                : Colors.white,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 35.0,
                                    backgroundImage: AssetImage(
                                        'assets/images/${index + 1}.jpg'),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chat.receptor.nameUser,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        child: Text(
                                          chat.lastMessage,
                                          style: const TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    '15:35',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  chat.unread
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7.0, vertical: 3),
                                          width: 40.0,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: const Text(
                                            'NEW',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : const Text(''),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }
}
