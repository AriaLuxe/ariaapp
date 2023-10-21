import 'package:ariapp/app/config/base_url_config.dart';
import 'package:ariapp/app/presentation/people/people_list/bloc/people_list_bloc.dart';
import 'package:ariapp/app/presentation/profiles/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PeopleList extends StatelessWidget {
  const PeopleList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PeopleListBloc, PeopleListState>(builder: (context, state){
      switch(state.peopleListStatus){
        case PeopleListStatus.error:
          return const Expanded(child: Center(child: Text('error al cargar elementos',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),));
        case PeopleListStatus.loading:
          return const Expanded(child: Center(child: CircularProgressIndicator(),));
        case PeopleListStatus.initial:
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        case PeopleListStatus.success:
          if (state.users.isEmpty) {
            return const Expanded(
              child:Column(
                children: [

                   Padding(
                     padding: EdgeInsets.symmetric(vertical: 50.0),
                     child: Text(
                          'No se encontraron resultados',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.white),
                        ),
                   ),

                ],
              ),

            );

          }else{
            return Expanded(
              child:  ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                     // print('ididi${chat.chatId}');
                      return GestureDetector(
                        onTap: () {
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  ChatScreen(chatId: chat.chatId!,),
                            ),
                          );*/
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListTile(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context) => ProfileScreen(user: user)));
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage('${BaseUrlConfig.baseUrlImage}${user.imgProfile}'),
                            ),
                            title: Text('${user.nameUser} ${user.lastName}', style: TextStyle(color: Colors.white),),
                            subtitle: Text(user.nickname, style: const TextStyle(color: Color(0xFFc0c0c0)),),
                          )
                        ),
                      );
                    },
                  ),
            );
          }

          }
    });
  }
}
