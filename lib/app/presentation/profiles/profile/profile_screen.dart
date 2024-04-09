import 'dart:ui';

import 'package:ariapp/app/infrastructure/data_sources/chats_data_provider.dart';
import 'package:ariapp/app/infrastructure/models/chat_model.dart';
import 'package:ariapp/app/infrastructure/repositories/chat_repository.dart';
import 'package:ariapp/app/infrastructure/repositories/message_repository.dart';
import 'package:ariapp/app/presentation/chats/chat/bloc/chat_bloc.dart';
import 'package:ariapp/app/presentation/chats/chat_list/bloc/chat_list_bloc.dart';
import 'package:ariapp/app/presentation/profiles/profile/bloc/follower_counter_bloc.dart';
import 'package:ariapp/app/presentation/profiles/profile/favorites_messages/bloc/favorites_messages_bloc.dart';
import 'package:ariapp/app/presentation/profiles/profile/favorites_messages/favorites_messages_screen.dart';
import 'package:ariapp/app/presentation/widgets/custom_dialog.dart';
import 'package:ariapp/app/presentation/widgets/custom_dialog_accept.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../config/base_url_config.dart';
import '../../../domain/entities/user_aria.dart';
import '../../../security/user_logged.dart';
import '../follow/bloc/follow_bloc.dart';
import '../follow/followers_list.dart';
import '../follow/followings_list.dart';
import '../my_profile/bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.user, super.key});

  final UserAria? user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userLoggedId = GetIt.instance<UserLogged>().user.id;

  Future<void> refresh() async {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    final followerCounterBloc = BlocProvider.of<FollowerCounterBloc>(context);

    profileBloc.fetchDataProfile(userLoggedId!);

    followerCounterBloc.fetchFollowerCounter(widget.user?.id ?? 0);

    profileBloc.checkFollow(widget.user?.id ?? 0);
    profileBloc.checkBlock(widget.user?.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final favoritesMessagesBloc =
        BlocProvider.of<FavoritesMessagesBloc>(context);

    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    final chatListBloc = BlocProvider.of<ChatListBloc>(context);
    final followerCounterBloc = BlocProvider.of<FollowerCounterBloc>(context);
    followerCounterBloc.fetchFollowerCounter(widget.user?.id ?? 0);
    profileBloc.checkFollow(widget.user?.id ?? 0);
    profileBloc.checkBlock(widget.user?.id ?? 0);

    String formatFollowers(int number) {
      if (number < 1000) {
        return number.toString();
      } else if (number < 1000000) {
        double formattedNumber = number / 1000.0;
        return '${formattedNumber.toStringAsFixed(1)}K';
      } else {
        double formattedNumber = number / 1000000.0;
        return '${formattedNumber.toStringAsFixed(1)}M';
      }
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "${BaseUrlConfig.baseUrlImage}${widget.user?.imgProfile}"),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFFFFFFF)
                                            .withOpacity(0.52),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_back_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFFFFFFF)
                                            .withOpacity(0.52),
                                      ),
                                      child: const Icon(
                                        Icons.favorite_border_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(32)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: Image.network(
                                  '${BaseUrlConfig.baseUrlImage}${widget.user?.imgProfile}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${widget.user?.nameUser} ${widget.user?.lastName}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21),
                            ),
                            Text(
                              '${widget.user?.nickname}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                                width: screenWidth * .8,
                                child: BlocBuilder<FollowerCounterBloc,
                                        FollowerCounterState>(
                                    builder: (context, state) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomDialogAccept(
                                                text:
                                                    'La informacion de los suscritos no esta disponible',
                                                onAccept: () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              formatFollowers(
                                                  state.numberOfSubscribers),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text(
                                              'Suscritos',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          //followerBloc.followersFetched();
                                          final followerBloc =
                                              BlocProvider.of<FollowBloc>(
                                                  context);

                                          followerBloc.followersFetched(
                                              userLoggedId!,
                                              widget.user!.id ?? 0);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const FollowersList()));
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              formatFollowers(
                                                  state.numberOfFollowers),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text(
                                              'Seguidores',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          final followerBloc =
                                              BlocProvider.of<FollowBloc>(
                                                  context);

                                          followerBloc.followingsFetched(
                                              userLoggedId!,
                                              widget.user!.id ?? 0);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const FollowingList(
                                                        isMyProfile: false,
                                                      )));
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              formatFollowers(
                                                  state.numberOfFollowings),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text(
                                              'Seguidos',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                })),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * .8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: const Color(0xFFebebeb)
                                        .withOpacity(0.26)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      BlocBuilder<FollowerCounterBloc,
                                          FollowerCounterState>(
                                        builder: (context, state) {
                                          return GestureDetector(
                                            onTap: () {
                                              //profileBloc.toggleFollowProfile(user?.id ?? 0, state.isFollowed);
                                              final followerCounterBloc =
                                                  BlocProvider.of<
                                                          FollowerCounterBloc>(
                                                      context);
                                              followerCounterBloc
                                                  .toggleFollowProfile(
                                                      widget.user?.id ?? 0,
                                                      state.isFollowed);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .37,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF354271),
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  state.isFollowed
                                                      ? 'Siguiendo'
                                                      : 'Seguir',
                                                  style: const TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          if (state.isBlock) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CustomDialogAccept(
                                                  text:
                                                      'Desbloquear para enviar mensaje',
                                                  onAccept: () {
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              },
                                            );
                                          } else {
                                            chatBloc.clearMessages();
                                            chatBloc.dataChatFetched(
                                                widget.user!.id!);
                                            final chatsDataProvider = GetIt
                                                .instance<ChatRepository>();
                                            final response =
                                                await chatsDataProvider
                                                    .createChat(userLoggedId!,
                                                        widget.user!.id!);
                                            if (response is ChatModel) {
                                              chatBloc.messageFetched(
                                                  response.chatId!, 0, 12);

                                              context.push(
                                                  '/chat/${response.chatId!}/${response.chatId!}/${widget.user!.id!}');
                                            } else if (response ==
                                                'This user is not a creator') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CustomDialogAccept(
                                                    text:
                                                        '¡Oops!\nNo se puede chatear con este usuario, ya que no es creador.',
                                                    onAccept: () {
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                },
                                              );
                                            } else if (response ==
                                                'Same user') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CustomDialogAccept(
                                                    text:
                                                        '¡Oops!\nNo puedes chatear contigo mismo :c',
                                                    onAccept: () {
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                },
                                              );
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .37,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF354271),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          child: const Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Chatear   ',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.send,
                                                  color: Colors.green,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color:
                                    const Color(0xFFebebeb).withOpacity(0.26),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  widget.user?.state?.isNotEmpty == true
                                      ? widget.user!.state!
                                      : 'Chatea conmigo',
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                            widget.user?.isCreator ?? false
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .8,
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      leading: const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                        size: 36,
                                      ),
                                      tileColor: const Color(0xFF354271)
                                          .withOpacity(0.97),
                                      textColor: Colors.white,
                                      title: const Text('Usuario creador'),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 6,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  //<-- SEE HERE
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                leading: const Icon(
                                  Icons.cake,
                                  color: Colors.white,
                                  size: 36,
                                ),
                                tileColor:
                                    const Color(0xFF354271).withOpacity(0.97),
                                textColor: Colors.white,
                                title: const Text('Cumpleaños'),
                                subtitle: Text(
                                    '${widget.user?.dateBirth?.day}/${widget.user?.dateBirth?.month}/${widget.user?.dateBirth?.year}   '),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  //<-- SEE HERE
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                leading: const Icon(
                                  Icons.flag,
                                  color: Colors.white,
                                  size: 36,
                                ),
                                tileColor:
                                    const Color(0xFF354271).withOpacity(0.97),
                                textColor: Colors.white,
                                title: const Text('País'),
                                subtitle: Text('${widget.user?.country}'),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * .8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: const Color(0xFFebebeb)
                                        .withOpacity(0.26)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF354271)
                                              .withOpacity(0.97),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: ListTile(
                                          title: const Text(
                                              'Mensajes favoritos',
                                              style: TextStyle(
                                                  color: Colors.green)),
                                          trailing: const Icon(Icons.star,
                                              color: Colors.green),
                                          onTap: () async {
                                            final messageRepository = GetIt
                                                .instance<MessageRepository>();
                                            final response =
                                                await messageRepository
                                                    .getFavoritesMessages(
                                                        userLoggedId!,
                                                        widget.user!.id!);
                                            if (response ==
                                                'Chat does not exists') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CustomDialogAccept(
                                                    text:
                                                        'Lo sentimo, no tienes chat con este usuario',
                                                    onAccept: () {
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                },
                                              );
                                            } else if (response ==
                                                'No messages') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CustomDialogAccept(
                                                    text:
                                                        'No tienes mensajes favoritos, selecciona algunos para poder verlos',
                                                    onAccept: () {
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                },
                                              );
                                            } else if (response == 'No chat') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CustomDialogAccept(
                                                    text:
                                                        'Lo sentimo, no tienes chat con este usuario',
                                                    onAccept: () {
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                },
                                              );
                                            } else {
                                              favoritesMessagesBloc
                                                  .favoritesMessageFetched(
                                                      widget.user!.id!);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FavoritesMessagesScreen(
                                                            userLookingId:
                                                                widget
                                                                    .user!.id!,
                                                          )));
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF354271)
                                              .withOpacity(0.97),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: ListTile(
                                          title: state.isBlock
                                              ? const Text(
                                                  'Desbloquear usuario',
                                                  style: TextStyle(
                                                      color: Colors.red))
                                              : const Text('Bloquear usuario',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                          trailing: state.isBlock
                                              ? const Icon(Icons.remove_circle,
                                                  color: Colors.red)
                                              : const Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Colors.red),
                                          onTap: () {
                                            chatBloc
                                                .onToggleBlockMe(state.isBlock);

                                            profileBloc.toggleBlockProfile(
                                                widget.user?.id ?? 0,
                                                state.isBlock);
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
                                              color: const Color(0xFF354271)
                                                  .withOpacity(0.97),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: state.isLoadingDeleteChat
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : ListTile(
                                                    title: const Text(
                                                        'Eliminar chat usuario',
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                                    trailing: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red),
                                                    onTap: () async {
                                                      final chatsDataProvider =
                                                          ChatsDataProvider();
                                                      final response =
                                                          await chatsDataProvider
                                                              .validateCreateChat(
                                                                  userLoggedId!,
                                                                  widget.user!
                                                                      .id!);
                                                      if (response ==
                                                          'Chat does not exist') {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return CustomDialogAccept(
                                                              text:
                                                                  '¡Oops!\nEl chat no existe.',
                                                              onAccept: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            );
                                                          },
                                                        );
                                                      } else if (int.parse(
                                                              response) >
                                                          0) {
                                                        int chatId =
                                                            int.parse(response);
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return CustomDialog(
                                                              text:
                                                                  '¿Estás seguro de eliminar chat?',
                                                              onOk: () {
                                                                chatListBloc
                                                                    .deleteChat(
                                                                        chatId);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              onCancel: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            );
                                                          },
                                                        );
                                                      }
                                                    }),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                )),
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
      ),
    );
  }
}
