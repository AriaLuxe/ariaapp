import 'package:ariapp/app/presentation/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/base_url_config.dart';
import '../../widgets/custom_button_follow.dart';
import 'bloc/follow_bloc.dart';

class FollowersList extends StatefulWidget {
  const FollowersList({Key? key}) : super(key: key);

  @override
  State<FollowersList> createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width*0.9,
            child: Column(
              children: [
                Header(title: 'Seguidores', onTap: (){
                  Navigator.pop(context);
                }),
                BlocBuilder<FollowBloc, FollowState>(
                  builder: (context, state) {
                    switch (state.followersStatus) {
                      case FollowStatus.error:
                        return const Center(
                          child: Text(
                            'Error al cargar seguidores',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      case FollowStatus.loading:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case FollowStatus.success:
                        if (state.followers.isEmpty) {
                          return  const Expanded(
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
                        } else {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: state.followers.length,
                              itemBuilder: (context, index) {
                                final follower = state.followers[index];
                                return ListTile(
                                  title: Text('${follower.nameUser} ${follower.lastName}',style: const TextStyle(color: Colors.white),maxLines: 1,),
                                  subtitle: Text(follower.nickName,maxLines: 1,style: const TextStyle(color: Color(0xFFc0c0c0)),),
                                  trailing: SizedBox(
                                      width: MediaQuery.of(context).size.width*0.2,
                                      child: CustomButtonFollow(onPressed: () {
                                        setState(() {
                                          follower.follow =!follower.follow;
                                         // BlocProvider.of<FollowBloc>(context).add((ToggleFollow(following,following.follow)));
                                        });
                                      }, text: follower.follow?'Siguiendo' : 'Seguir' , color: follower.follow ? const Color(0xFF354271): const  Color(0xFF5368d6),)),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage('${BaseUrlConfig.baseUrlImage}${follower.imgProfile}'),
                                  ),

                                  onTap: () {
                                     },
                                );
                              },
                            ),
                          );
                        }
                      default:
                        return const Expanded(
                          child:  Center(
                              child: CircularProgressIndicator(),
                          ),
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}