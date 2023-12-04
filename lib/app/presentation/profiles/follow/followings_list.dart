import 'package:ariapp/app/domain/entities/follower.dart';
import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/bloc/profile_bloc.dart';
import 'package:ariapp/app/presentation/profiles/profile/bloc/follower_counter_bloc.dart';
import 'package:ariapp/app/presentation/profiles/profile/profile_screen.dart';
import 'package:ariapp/app/presentation/widgets/arrow_back.dart';
import 'package:ariapp/app/security/user_logged.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../config/base_url_config.dart';
import '../../widgets/custom_button_follow.dart';
import 'bloc/follow_bloc.dart';

class FollowingList extends StatefulWidget {
  const FollowingList({Key? key, required this.isMyProfile}) : super(key: key);
  final bool isMyProfile;
  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ArrowBack(onTap: (){
                      Navigator.pop(context);
                    }),
                    const SizedBox(
                      width: 200,
                      child: Text(
                        'Seguidos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 42,),
                  ],
                ),

                BlocBuilder<FollowBloc, FollowState>(
                  builder: (context, state) {
                    switch (state.followingStatus) {
                      case FollowStatus.error:
                        return const Center(
                          child: Text(
                            'Error al cargar following',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      case FollowStatus.loading:
                        return const Expanded(
                          child:  Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      case FollowStatus.success:
                        if (state.following.isEmpty) {
                          return const Expanded(
                            child: Column(
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
                              itemCount: state.following.length,
                              itemBuilder: (context, index) {
                                final following = state.following[index];
                                bool isFollowLocal = state.following[index].follow;
                                return ListTile(
                                  title: InkWell(
                                      onTap: (){
                                        navigateToProfile(following);
                                      },
                                      child: Text('${following.nameUser} ${following.lastName}',style: const TextStyle(color: Colors.white),maxLines: 1)),
                                  subtitle: InkWell(
                                    onTap: (){
                                        navigateToProfile(following);
                                    },
                                      child: Text(following.nickName,style: const TextStyle(color: Color(0xFFc0c0c0)),maxLines: 1)),
                                  trailing: SizedBox(
                                      width: MediaQuery.of(context).size.width*0.2,
                                      child: CustomButtonFollow(onPressed: () {
                                        setState(() {
                                          following.follow = !following.follow;
                                          isFollowLocal = !isFollowLocal;
                                        });
                                          final followerBloc = BlocProvider.of<FollowBloc>(context);
                                          followerBloc.toggleFollow(following.idRequest!, isFollowLocal, following);
                                          final userLoggedId = GetIt.instance<UserLogged>().user.id;
                                          final followerCounterBloc = BlocProvider.of<FollowerCounterBloc>(context);
                                          if(widget.isMyProfile){
                                            final profileBloc = Provider.of<ProfileBloc>(context, listen: false);
                                            profileBloc.fetchDataProfile(userLoggedId!);
                                          }else{
                                            followerCounterBloc.fetchFollowerCounter(following.idUser);
                                          }

                                      }, text: following.follow?'Siguiendo' : 'Seguir' , color: following.follow ? const Color(0xFF354271): const  Color(0xFF5368d6), )),
                                  leading: InkWell(
                                  onTap: (){
                                navigateToProfile(following);
                                },
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage('${BaseUrlConfig.baseUrlImage}${following.imgProfile}'),
                                    ),
                                  ),

                                  onTap: () {

                                  },
                                );
                              },
                            ),
                          );
                        }
                      default:
                        return const Center(
                          child: Text(
                            'Comuníquese por email a aia@gmail.com',
                             style: TextStyle(fontWeight: FontWeight.bold),
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
  void navigateToProfile(Follower follower)async {
    final userAriaRepository = GetIt.instance<UserAriaRepository>();
    final user = await userAriaRepository.getUserById(follower.idUser);
    Navigator.push(context,MaterialPageRoute(builder: (context) => ProfileScreen( user: user)));

  }
}
