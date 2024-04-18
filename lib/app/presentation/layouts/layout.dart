import 'package:ariapp/app/config/base_url_config.dart';
import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/presentation/notifications/notifications_bloc.dart';
import 'package:ariapp/app/presentation/people/people_list/bloc/people_list_bloc.dart';
import 'package:ariapp/app/presentation/profiles/follow/bloc/follow_bloc.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/bloc/profile_bloc.dart';
import 'package:ariapp/app/presentation/voice/bloc/voice_bloc.dart';
import 'package:ariapp/app/presentation/voice/voice_clone/bloc/voice_clone_bloc.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/user_aria.dart';
import '../../security/user_logged.dart';
import '../profiles/my_profile/update_information/bloc/my_profile_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.navigationShell}) : super(key: key);
  final StatefulNavigationShell navigationShell;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  UserAria? user;
  final userRepository = GetIt.instance<UserAriaRepository>();
  final userLogged = GetIt.instance<UserLogged>();

  Future<void> _loadUserData() async {
    int? userId = await SharedPreferencesManager.getUserId();
    user = await userRepository.getUserById(userId!);
  }

  int backButtonCounter = 0;

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        backButtonCounter++;
        if (backButtonCounter > 1) {
          SystemNavigator.pop();
          return true;
        } else {
          backButtonCounter = 0;
          return false;
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FollowBloc(),
          ),
          BlocProvider(
            create: (context) => PeopleListBloc(),
          ),
          BlocProvider(
            create: (context) => MyProfileBloc(),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(),
          ),
          BlocProvider(
            create: (context) => VoiceBloc(),
          ),
          BlocProvider(
            create: (context) => VoiceCloneBloc(),
          ),
        ],
        child: Scaffold(
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: widget.navigationShell,
          ), //_pages[_selectedIndex],
          bottomNavigationBar: SizedBox(
            height: 52,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF5368D6),
                        Color(0xFF9269BE),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                      canvasColor: Colors.transparent,
                      textTheme: Theme.of(context).textTheme.copyWith(
                          bodySmall: const TextStyle(color: Colors.white))),
                  child: BottomNavigationBar(
                    unselectedFontSize: 13,
                    selectedFontSize: 13,
                    elevation: 0,
                    selectedIconTheme: const IconThemeData(size: 20),
                    unselectedIconTheme: const IconThemeData(size: 20),
                    items: [
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.forum),
                        label: 'Chats',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.travel_explore),
                        label: 'Personas',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.graphic_eq),
                        label: 'Crear',
                      ),
                      BottomNavigationBarItem(
                        icon: BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            return UserProfileIcon(
                              profileImageURL:
                                  '${BaseUrlConfig.baseUrlImage}${state.urlProfile}',
                              genericImageURL:
                                  'https://cdn-icons-png.flaticon.com/512/660/660611.png',
                            );
                          },
                        ),
                        label: '',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    onTap: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                      _goBranch(_selectedIndex);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserProfileIcon extends StatelessWidget {
  final String profileImageURL;
  final String genericImageURL;

  const UserProfileIcon({
    super.key,
    required this.profileImageURL,
    required this.genericImageURL,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 13,
      backgroundImage: NetworkImage(profileImageURL),
      backgroundColor: Styles.primaryColor,
    );
  }
}
