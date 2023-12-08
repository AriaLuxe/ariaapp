import 'package:ariapp/app/domain/entities/follower.dart';
import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/presentation/profiles/follow/bloc/follow_bloc.dart';
import 'package:ariapp/app/presentation/profiles/profile/bloc/follower_counter_bloc.dart';
import 'package:ariapp/app/presentation/profiles/profile/profile_screen.dart';
import 'package:ariapp/app/presentation/widgets/arrow_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../config/base_url_config.dart';
import '../../widgets/custom_button_follow.dart';

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
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ArrowBack(onTap: () {
                      Navigator.pop(context);
                    }),
                    const SizedBox(
                      width: 200,
                      child: Text(
                        'Seguidores',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 42,
                    ),
                  ],
                ),
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
                            child: ListView.builder(
                              itemCount: state.followers.length,
                              itemBuilder: (context, index) {
                                final follower = state.followers[index];
                                bool isFollowLocal =
                                    state.followers[index].follow;

                                return ListTile(
                                  title: InkWell(
                                    onTap: () {
                                      navigateToProfile(follower);
                                    },
                                    child: Text(
                                      '${follower.nameUser} '
                                      '${follower.lastName}',
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white),
                                      maxLines: 1,
                                    ),
                                  ),
                                  subtitle: InkWell(
                                    onTap: () {
                                      navigateToProfile(follower);
                                    },
                                    child: Text(
                                      follower.nickName,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Color(0xFFc0c0c0)),
                                    ),
                                  ),
                                  trailing: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: CustomButtonFollow(
                                        onPressed: () {
                                          setState(() {
                                            follower.follow = !follower.follow;
                                            isFollowLocal = !isFollowLocal;
                                          });
                                          final followerBloc =
                                              BlocProvider.of<FollowBloc>(
                                                  context);
                                          followerBloc.toggleFollow(
                                              follower.idRequest!,
                                              isFollowLocal,
                                              follower);
                                          final followerCounterBloc =
                                              BlocProvider.of<
                                                  FollowerCounterBloc>(context);

                                          followerCounterBloc
                                              .fetchFollowerCounter(
                                                  follower.idUser);
                                        },
                                        text: follower.follow
                                            ? 'Siguiendo'
                                            : 'Seguir',
                                        color: follower.follow
                                            ? const Color(0xFF354271)
                                            : const Color(0xFF5368d6),
                                      )),
                                  leading: InkWell(
                                    onTap: () {
                                      navigateToProfile(follower);
                                    },
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          '${BaseUrlConfig.baseUrlImage}${follower.imgProfile}'),
                                    ),
                                  ),
                                  onTap: () async {
                                    //TODO: CAMBIAR NAVEGACION
                                    //final userAriaRepository = GetIt.instance<UserAriaRepository>();
                                    // final user = await userAriaRepository.getUserById(follower.idUser);
                                    //Navigator.push(context,MaterialPageRoute(builder: (context) => ProfileScreen( user: user)));
                                  },
                                );
                              },
                            ),
                          );
                        }
                      default:
                        return const Expanded(
                          child: Center(
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

  void navigateToProfile(Follower follower) async {
    final userAriaRepository = GetIt.instance<UserAriaRepository>();
    final user = await userAriaRepository.getUserById(follower.idUser);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProfileScreen(user: user)));
  }
}
