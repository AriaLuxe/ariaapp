import 'package:animate_do/animate_do.dart';
import 'package:ariapp/app/config/base_url_config.dart';
import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/infrastructure/models/chat_model.dart';
import 'package:ariapp/app/infrastructure/repositories/chat_repository.dart';
import 'package:ariapp/app/presentation/chats/chat/bloc/chat_bloc.dart';
import 'package:ariapp/app/presentation/people/people_list/bloc/people_list_bloc.dart';
import 'package:ariapp/app/presentation/profiles/profile/profile_screen.dart';
import 'package:ariapp/app/presentation/widgets/custom_dialog_accept.dart';
import 'package:ariapp/app/security/user_logged.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class PeopleList extends StatefulWidget {
  const PeopleList({super.key});

  @override
  State<PeopleList> createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  int page = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final peopleListBloc = BlocProvider.of<PeopleListBloc>(context);
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        page++;
        peopleListBloc.loadMoreUsers(
          page,
          10,
        );
      }
    });
    super.initState();
  }

  Future<void> refresh() async {
    final peopleListBloc = BlocProvider.of<PeopleListBloc>(context);
    peopleListBloc.peopleFetched(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    final userLoggedId = GetIt.instance<UserLogged>().user.id;

    return BlocBuilder<PeopleListBloc, PeopleListState>(
        builder: (context, state) {
      final users = state.users;

      switch (state.peopleListStatus) {
        case PeopleListStatus.error:
          return const Expanded(
              child: Center(
            child: Text('error al cargar elementos',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
          ));
        case PeopleListStatus.loading:
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        case PeopleListStatus.initial:
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        case PeopleListStatus.success:
          if (state.users.isEmpty) {
            return const Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 50.0),
                    child: Text(
                      'No se encontraron resultados',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  ),
                ],
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
                    itemCount: state.users.length + 1,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      if (index < users.length) {
                        final user = state.users[index];
                        return user.enabled!
                            ? GestureDetector(
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen(user: user)));
                                      },
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            '${BaseUrlConfig.baseUrlImage}${user.imgProfile}'),
                                      ),
                                      title: Text(
                                        '${user.nameUser} ${user.lastName}',
                                        maxLines: 1,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        user.nickname,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Color(0xFFc0c0c0)),
                                      ),
                                    )),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  '${BaseUrlConfig.baseUrlImage}${user.imgProfile}'),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  user.nameUser,
                                                  style: TextStyle(
                                                      color:
                                                          Styles.primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                                Text(
                                                  user.lastName,
                                                  maxLines: 1,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            width: double.infinity,
                                            height: 380,
                                            '${BaseUrlConfig.baseUrlImage}${user.nickname}',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .supervised_user_circle_sharp,
                                                color: Styles.primaryColor,
                                              ),
                                              const Text('24k Suscritos')
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              chatBloc.clearMessages();
                                              chatBloc
                                                  .dataChatFetched(user.id!);
                                              final chatsDataProvider = GetIt
                                                  .instance<ChatRepository>();
                                              final response =
                                                  await chatsDataProvider
                                                      .createChat(userLoggedId!,
                                                          user.id!);
                                              if (response is ChatModel) {
                                                chatBloc.messageFetched(
                                                    response.chatId!, 0, 12);

                                                context.push(
                                                    '/chat/${response.chatId!}/${response.chatId!}/${user.id!}');
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
                                              /*chatBloc
                                                  .dataChatFetched(chat.userId);
                                              chatBloc.messageFetched(
                                                  chat.chatId!, 0, 8);
                                              context.push(
                                                  '/chat/${chat.chatId}/${chat.chatId!}/${chat.userId}');
                                            */
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.lyrics,
                                                  color: Styles.primaryColor,
                                                ),
                                                const Text('Chatear')
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      } else {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: state.hasMoreMessages
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Flash(
                                    child: const Center(
                                        child: Text(
                                    'No hay mas usuarios',
                                    style: TextStyle(color: Colors.grey),
                                  ))));
                      }
                    },
                  ),
                ),
              ),
            );
          }
      }
    });
  }
}
