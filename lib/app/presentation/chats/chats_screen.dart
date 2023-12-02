import 'package:ariapp/app/presentation/profiles/my_profile/bloc/profile_bloc.dart';
import 'package:ariapp/app/security/user_logged.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';


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
    final userId = GetIt.instance<UserLogged>().user.id;
    final profileBloc = context.watch<ProfileBloc>();
    profileBloc.fetchDataProfile(userId!);
    return  const SafeArea(
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text('Chats',style: TextStyle(color: Colors.white,fontSize: 24),),
                  ),
                  CustomSearchBar(title:'Buscar chat'),
                  ChatsList(),
                ],
            ),
    );
  }
}
