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

  @override
  Widget build(BuildContext context) {
    final chatListBloc = BlocProvider.of<ChatListBloc>(context);
    chatListBloc.chatsFetched();
    final userId = GetIt.instance<UserLogged>().user.id;
    final profileBloc = context.watch<ProfileBloc>();
    profileBloc.fetchDataProfile(userId!);
    return   SafeArea(
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0, right:25, top:  15),
                    child: Text('Chats',style: TextStyle(color: Colors.white,fontSize: 24),),
                  ),
                  CustomSearchBar(
                    title: 'Buscar usuario...',
                    onChanged: (keyword){
                      chatListBloc.searchChats(keyword,userId);
                    },),
                  const ChatsList(),
                ],
            ),
    );
  }
}
