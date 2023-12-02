import 'dart:ui';

import 'package:ariapp/app/infrastructure/data_sources/chats_data_provider.dart';
import 'package:ariapp/app/presentation/chats/chat/bloc/chat_bloc.dart';
import 'package:ariapp/app/presentation/chats/chat/chat_screen.dart';
import 'package:ariapp/app/presentation/chats/chat_list/bloc/chat_list_bloc.dart';
import 'package:ariapp/app/presentation/profiles/profile/bloc/follower_counter_bloc.dart';
import 'package:ariapp/app/presentation/widgets/custom_dialog_accept.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../config/base_url_config.dart';
import '../../../domain/entities/user_aria.dart';
import '../../../security/user_logged.dart';
import '../follow/bloc/follow_bloc.dart';
import '../follow/followers_list.dart';
import '../follow/followings_list.dart';
import '../my_profile/bloc/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
   ProfileScreen( {required this.user, super.key});
  final UserAria? user;
  final userLoggedId = GetIt.instance<UserLogged>().user.id;
  @override
  Widget build(BuildContext context) {
    print('Id perfil: ${user?.id}');
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    final chatListBloc = BlocProvider.of<ChatListBloc>(context);

    final followerCounterBloc = BlocProvider.of<FollowerCounterBloc>(context);

    followerCounterBloc.fetchFollowerCounter(user?.id ?? 0);

    profileBloc.checkFollow(user?.id ?? 0);
    profileBloc.checkBlock(user?.id ?? 0);
    profileBloc.fetchChat(userLoggedId!, user?.id ?? 0);

    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        int chatIdX = state.chatId;
        return Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("${BaseUrlConfig.baseUrlImage}${user?.imgProfile}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x00000000),
                              Color(0xFF151F42),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration:  BoxDecoration(
                                  border: Border.all(color: Colors.black,),
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFFFFFF).withOpacity(0.52),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),

                                decoration:  BoxDecoration(
                                  border: Border.all(color: Colors.black,),
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFFFFFF).withOpacity(0.52),
                                ),
                                child: const Icon(
                                  Icons.favorite_border_outlined,

                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height*0.35,
                        width: MediaQuery.of(context).size.width*0.6,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(32)
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),

                          child: Image.network(
                            '${BaseUrlConfig.baseUrlImage}${user?.imgProfile}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),

                      Text('${user?.nameUser} ${user?.lastName}',style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 21),),

                      Text('${user?.nickname}',style: const TextStyle(color: Colors.white,fontSize: 18),),
                      const SizedBox(height: 10,),
                      SizedBox(
                        width: screenWidth*.8,
                        child: BlocBuilder<FollowerCounterBloc, FollowerCounterState>(
                          builder: (context, state) {
                            return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(state.numberOfSubscribers.toString(),style: const TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.bold),),
                                const Text('Suscritos',style: TextStyle(color: Colors.white),),
                              ],
                            ),
                            GestureDetector(
                              onTap: (){
                                //followerBloc.followersFetched();
                                final followerBloc = BlocProvider.of<FollowBloc>(context);

                                followerBloc.followersFetched(userLoggedId!,user!.id ?? 0);
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  const FollowersList()));
                              },
                              child: Column(
                                children: [
                                  Text(state.numberOfFollowers.toString(),style: const TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.bold),),
                                  const Text('Seguidores',style: TextStyle(color: Colors.white),),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                final followerBloc = BlocProvider.of<FollowBloc>(context);

                                followerBloc.followingsFetched(userLoggedId!, user!.id ?? 0);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const FollowingList()));

                              },
                              child: Column(
                                children: [
                                  Text(state.numberOfFollowings.toString(),style: const TextStyle(color: Colors.white,fontSize: 21, fontWeight: FontWeight.bold),),
                                  const Text('Seguidos',style: TextStyle(color: Colors.white),),
                                ],
                              ),
                            )
                          ],
                        );
  },
),
                      ),
                      const SizedBox(height: 30,),
                      Container(
                        height: 60,
                          width: MediaQuery.of(context).size.width*.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: const Color(0xFFebebeb).withOpacity(0.26)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            GestureDetector(
                            onTap: (){

                                profileBloc.toggleFollowProfile(user?.id ?? 0, state.isFollowed);


                            },
                              child:
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width*.37,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF354271),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child:  Center(
                                  child: Text(
                                    state.isFollowed ? 'Siguiendo' : 'Seguir',
                                    style:  const TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                                GestureDetector(
                                  onTap: () async {
                                    if(state.isBlock){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomDialogAccept(
                                            text: 'Desbloquear para enviar mensaje',
                                             onAccept: () {
                                              Navigator.pop(context);
                                             },
                                          );
                                        },
                                      );
                                    }else {
                                      chatBloc.clearMessages();
                                      chatBloc.dataChatFetched(user!.id!);
                                      final  chatsDataProvider = ChatsDataProvider();
                                      final chat = await chatsDataProvider.createChat(userLoggedId!, user!.id!);
                                      chatBloc.messageFetched(chat.chatId!,0,8);
                                      Navigator.push(context,MaterialPageRoute(
                                          builder: (context) =>  ChatScreen(userId: user!.id!, chatId: chat.chatId!, userReceivedId: user!.id!,)));
                                    }
                                    },
                                  child:
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width*.37,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF354271),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Chatear   ',
                                            style:  TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                          Icon(Icons.send,color: Colors.green,)
                                        ],
                                      ),
                                    ),
                                  ),

                                ),

                              ],
                            ),

                          )
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color:const Color(0xFFebebeb).withOpacity(0.26),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            user?.state?.isNotEmpty == true ? user!.state! : 'Sin estado',
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*.8,

                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          leading: const Icon(Icons.people, color: Colors.white,size: 36,),
                          tileColor: const Color(0xFF354271).withOpacity(0.97),
                          textColor: Colors.white,
                          title: const Text('Suscritos'),
                          subtitle: Text(state.numberOfSubscribers.toString()),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*.8,
                        child: ListTile(
                          shape: RoundedRectangleBorder( //<-- SEE HERE
                            borderRadius: BorderRadius.circular(25),
                          ),
                          leading: const Icon(Icons.cake, color: Colors.white,size: 36,),
                          tileColor: const Color(0xFF354271).withOpacity(0.97),
                          textColor: Colors.white,
                          title: const Text('Cumpleaños'),
                          subtitle: Text('${user?.dateBirth?.day}/${user?.dateBirth?.month}/${user?.dateBirth?.year}   '),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*.8,

                        child: ListTile(
                          shape: RoundedRectangleBorder( //<-- SEE HERE
                            borderRadius: BorderRadius.circular(25),
                          ),
                          leading: const Icon(Icons.flag, color: Colors.white,size: 36,),
                          tileColor: const Color(0xFF354271).withOpacity(0.97),
                          textColor: Colors.white,
                          title: const Text('Pais'),
                          subtitle: Text('${user?.country}'),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color(0xFFebebeb).withOpacity(0.26)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF354271).withOpacity(0.97),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: ListTile(
                                  title: const Text('Favoritos', style: TextStyle(color: Colors.green)),
                                  trailing: const Icon(Icons.star, color: Colors.green),
                                  onTap: () {},
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF354271).withOpacity(0.97),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: ListTile(
                                  title: state.isBlock ?const Text('Desbloquear usuario', style: TextStyle(color: Colors.red)):const Text('Bloquear usuario', style: TextStyle(color: Colors.red)),
                                  trailing: state.isBlock ?const Icon(Icons.remove_circle, color: Colors.red):const Icon(Icons.remove_circle_outline, color: Colors.red),
                                  onTap: () {
                                    profileBloc.toggleBlockProfile(user?.id ?? 0, state.isBlock);
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              BlocBuilder<ChatListBloc, ChatListState>(

                              builder: (context, state) {
                                 return Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF354271).withOpacity(0.97),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: state.isLoadingDeleteChat? const Center(child:CircularProgressIndicator()):ListTile(
                                  title: const Text('Eliminar chat usuario', style: TextStyle(color: Colors.red)),
                                  trailing: const Icon(Icons.delete, color: Colors.red),
                                  onTap: () {
                                    chatListBloc.deleteChat(chatIdX);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialogAccept(
                                          text: 'Chat eliminado',
                                          onAccept: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
  },
),
                            ],
                          ),
                        )
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ],
        );
  },
),
      ),
    );
  }
}
