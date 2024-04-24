import 'package:ariapp/app/config/base_url_config.dart';
import 'package:ariapp/app/config/helpers/custom_dialogs.dart';
import 'package:ariapp/app/infrastructure/data_sources/users_data_provider.dart';
import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/presentation/profiles/follow/bloc/follow_bloc.dart';
import 'package:ariapp/app/presentation/profiles/follow/followers_list.dart';
import 'package:ariapp/app/presentation/profiles/follow/followings_list.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/bloc/profile_bloc.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/update_state/update_state.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/widgets/my_profile_option.dart';
import 'package:ariapp/app/presentation/widgets/custom_button_blue.dart';
import 'package:ariapp/app/presentation/widgets/custom_button_delete_account.dart';
import 'package:ariapp/app/presentation/widgets/custom_dialog.dart';
import 'package:ariapp/app/presentation/widgets/custom_dialog_accept.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../config/styles.dart';
import '../../../security/user_logged.dart';
import 'update_state/bloc/update_state_bloc.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateStateBloc(),
      child: const SizedBox(child: MyProfile()),
    );
  }
}

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  int? userLoggedId = GetIt.instance<UserLogged>().user.id;
  bool isLoadingDeletedAccount = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() {
    final userLogged = GetIt.instance<UserLogged>();
    _nameController.text = userLogged.user.nameUser;
    _lastNameController.text = userLogged.user.lastName;
    _emailController.text = userLogged.user.email;
  }

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

  Future<void> refresh() async {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);

    profileBloc.fetchDataProfile(userLoggedId!);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final profileBloc = context.watch<ProfileBloc>();

    profileBloc.fetchDataProfile(userLoggedId!);
    return RefreshIndicator(
      onRefresh: refresh,
      child: SafeArea(
        child: SizedBox(
          width: size.width,
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.width * 0.04),
                    const Text('Mi perfil',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 21)),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.03),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: size.width * 0.01,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          context.go("/my_profile/profile_image");
                        },
                        child: CircleAvatar(
                          backgroundColor: Styles.primaryColor,
                          radius: size.height * 0.09,
                          backgroundImage: NetworkImage(
                              '${BaseUrlConfig.baseUrlImage}${state.urlProfile}'),
                        ),
                      ),
                    ),
                    Text('${state.name} ${state.lastName}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 21)),
                    Text(state.email,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18)),
                    SizedBox(height: size.height * 0.05),
                    SizedBox(
                      width: size.width * .8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              CustomDialogs().showConfirmationDialog(
                                context: context,
                                title: 'Alerta',
                                content: 'Próximamente...',
                                onAccept: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Text(
                                  formatFollowers(state.numberOfSubscribers),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Suscritos',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              final followerBloc =
                                  BlocProvider.of<FollowBloc>(context);
                              followerBloc.followersFetched(
                                  userLoggedId!, userLoggedId!);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FollowersList()));
                            },
                            child: Column(
                              children: [
                                Text(
                                  formatFollowers(state.numberOfFollowers),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Seguidores',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const FollowingList(
                                            isMyProfile: true,
                                          )));
                              final followerBloc =
                                  BlocProvider.of<FollowBloc>(context);
                              followerBloc.followingsFetched(
                                  userLoggedId!, userLoggedId!);
                            },
                            child: Column(
                              children: [
                                Text(
                                  formatFollowers(state.numberOfFollowings),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Seguidos',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    SizedBox(
                      width: size.width * .8,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        tileColor: const Color(0xFFebebeb).withOpacity(0.26),
                        textColor: Colors.white,
                        title: state.state.isEmpty
                            ? const Text(
                                textAlign: TextAlign.center,
                                'Agrega un estado',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(state.state),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onTap: () {
                          //context.go("/my_profile/update_state",);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateState(
                                        state: state.state,
                                      )));
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    SizedBox(
                        width: size.width * .8,
                        child: MyProfileOption(
                          icon: Icons.person_search,
                          title: 'Mi informacion',
                          onTap: () {
                            context.go("/my_profile/my_information");
                          },
                        )),
                    SizedBox(height: size.height * 0.02),
                    SizedBox(
                        width: size.width * .8,
                        child: MyProfileOption(
                          icon: Icons.lock,
                          title: 'Cambiar contraseña',
                          onTap: () {
                            context.go("/my_profile/update_password");
                          },
                        )),
                    SizedBox(height: size.height * 0.02),
                    SizedBox(
                        width: size.width * .8,
                        child: MyProfileOption(
                          icon: Icons.email,
                          title: 'Cambiar correo',
                          onTap: () {
                            context.go("/my_profile/update_email");
                          },
                        )),
                    SizedBox(height: size.height * 0.02),
                    SizedBox(
                        width: size.width * .8,
                        child: MyProfileOption(
                          icon: Icons.lightbulb_outline,
                          title: 'Enviar sugerencias',
                          onTap: () {
                            context.go("/my_profile/sugerir");
                          },
                        )),
                    SizedBox(height: size.height * 0.04),
                    SizedBox(
                        width: size.width * .8,
                        child: CustomButtonBlue(
                            text: 'Cerrar sesión',
                            onPressed: () async {
                              await SharedPreferencesManager.clearToken();
                              await SharedPreferencesManager.clearUserId();
                              await SharedPreferencesManager.clearEmail();
                              GetIt.I.unregister<UserLogged>();
                              context.pushReplacement('/sign_in');
                            },
                            width: 0.5)),
                    SizedBox(height: size.height * 0.03),
                    SizedBox(
                        width: size.width * .8,
                        child: isLoadingDeletedAccount
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : CustomButtonDeleteAccount(
                                text: 'Eliminar Cuenta ',
                                onPressed: () async {
                                  final userId = await SharedPreferencesManager
                                      .getUserId();
                                  final userAriaRepository =
                                      GetIt.instance<UserAriaRepository>();

                                  CustomDialogs().showCustomDialog(
                                      context: context,
                                      text:
                                          '¿Estás seguro de eliminar tu cuenta?',
                                      onOk: () async {
                                        setState(() {
                                          isLoadingDeletedAccount = true;
                                        });
                                        final response =
                                            await userAriaRepository
                                                .deleteAccount(userId!);
                                        if (response == 'done') {
                                          await SharedPreferencesManager
                                              .clearToken();
                                          await SharedPreferencesManager
                                              .clearUserId();
                                          await SharedPreferencesManager
                                              .clearEmail();
                                          GetIt.I.unregister<UserLogged>();
                                          context.pushReplacement('/sign_in');
                                          setState(() {
                                            isLoadingDeletedAccount = false;
                                          });
                                        } else if (response ==
                                            'No exists user') {
                                          CustomDialogs()
                                              .showConfirmationDialog(
                                            context: context,
                                            title: 'Alerta',
                                            content:
                                                'Por favor, vuelve a iniciar sesión',
                                            onAccept: () {
                                              Navigator.pop(context);
                                            },
                                          );
                                        }
                                      },
                                      onCancel: () {
                                        Navigator.pop(context);
                                      });
                                },
                                width: 0.5)),
                    SizedBox(height: size.height * 0.03),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
