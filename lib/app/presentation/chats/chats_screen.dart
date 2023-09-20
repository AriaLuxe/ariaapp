import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/styles.dart';
import '../layouts/widgets/header.dart';
import '../widgets/custom_search_bar.dart';
import 'chat_list/bloc/chat_list_bloc.dart';
import 'chat_list/chats_list.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});
  void _newMessage(BuildContext context, ChatListBloc chatListBloc) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) => Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          'Nuevo Chat',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            chatListBloc.chatsAdded(1, 2);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Crear'),
                        ),
                      ],
                    ),
                  ),
                ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatListBloc = BlocProvider.of<ChatListBloc>(context);
    chatListBloc.chatsFetched();
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Styles.primaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            children: [
              Header(
                title: 'Chats',
                iconData: Icons.chat,
                onPressed: () {
                  _newMessage(context, chatListBloc);
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: const Column(
              children: [
                CustomSearchBar(),
                ChatsList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
