import 'package:ariapp/app/presentation/widgets/custom_button_blue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/base_url_config.dart';
import '../../widgets/custom_button_follow.dart';
import '../../widgets/header.dart';
import 'bloc/follow_bloc.dart';

class FollowingList extends StatefulWidget {
  const FollowingList({Key? key}) : super(key: key);

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
                Header(title: 'Siguiendo', onTap: () {
                  Navigator.pop(context);
                }),
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
                                print('bucle');
                                print(following.idUser);
                                return ListTile(
                                  title: Text('${following.nameUser} ${following.lastName}',style: const TextStyle(color: Colors.white),maxLines: 1),
                                  subtitle: Text(following.nickName,style: const TextStyle(color: Color(0xFFc0c0c0)),maxLines: 1),
                                  trailing: SizedBox(
                                      width: MediaQuery.of(context).size.width*0.2,
                                      child: CustomButtonFollow(onPressed: () {
                                        setState(() {
                                          following.follow = !following.follow;
                                          isFollowLocal = !isFollowLocal;
                                          print('following.nameUser');
                                          print(following.nameUser);
                                          print('following.idUser');
                                          print(following.idUser);
                                          print('following.nameUser');
                                          print(following.nameUser);



                                          BlocProvider.of<FollowBloc>(context).add(
                                            ToggleFollow(following.idRequest!, isFollowLocal, following),
                                          );
                                        });
                                      }, text: following.follow?'Siguiendo' : 'Seguir' , color: following.follow ? const Color(0xFF354271): const  Color(0xFF5368d6), )),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage('${BaseUrlConfig.baseUrlImage}${following.imgProfile}'),
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
}
