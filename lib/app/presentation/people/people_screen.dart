import 'package:ariapp/app/domain/entities/user_aria.dart';
import 'package:ariapp/app/infrastructure/data_sources/users_data_provider.dart';
import 'package:ariapp/app/presentation/people/people_list/people_list.dart';
import 'package:ariapp/app/presentation/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'people_list/bloc/people_list_bloc.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  List<UserAria>? users;

  final usersDataProvider = UsersDataProvider();
  @override
  Widget build(BuildContext context) {
    final peopleListBloc = BlocProvider.of<PeopleListBloc>(context);
    peopleListBloc.peopleFetched(0,10);

    return   SafeArea(
      child: Column(
          children: [
            CustomSearchBar(
              title: 'Buscar usuario...',
              onChanged: (keyword){
              peopleListBloc.searchPeople(keyword);
            },),
            const PeopleList(),
          ],
        ),
    );
  }
}
