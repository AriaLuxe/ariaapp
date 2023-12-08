import 'package:animate_do/animate_do.dart';
import 'package:ariapp/app/config/base_url_config.dart';
import 'package:ariapp/app/presentation/people/people_list/bloc/people_list_bloc.dart';
import 'package:ariapp/app/presentation/profiles/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                        return GestureDetector(
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
