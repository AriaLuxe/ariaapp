import 'package:ariapp/app/config/base_url_config.dart';
import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/presentation/people/people_list/bloc/people_list_bloc.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/my_profile_screen.dart';
import 'package:ariapp/app/presentation/profiles/profile/profile_screen.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../config/styles.dart';
import '../../domain/entities/user_aria.dart';
import '../../security/user_logged.dart';
import '../chats/chat_list/bloc/chat_list_bloc.dart';
import '../chats/chats_screen.dart';
import '../people/people_screen.dart';
import '../voice/voice_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;
   UserAria? user;
final userRepository = GetIt.instance<UserAriaRepository>();
  final userLogged = GetIt.instance<UserLogged>();

  final List<Widget> _pages = [
    const ChatsScreen(),
    const PeopleScreen(),
    const VoiceScreen(),
    MyProfileScreen(),
  ];
  Future<void> _loadUserData() async {
    int? userId = await SharedPreferencesManager.getUserId();
    user = await userRepository.getUserById(userId!);
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    _loadUserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatListBloc(),
        ),
        BlocProvider(
          create: (context) => PeopleListBloc(),
        ),
      ],
      child:  Scaffold(
          body: _pages[_selectedIndex],
          bottomNavigationBar: SizedBox(
            height: 80,
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
                    //  primaryColor: Styles.primaryColor,
                      textTheme: Theme
                          .of(context)
                          .textTheme
                          .copyWith(
                          bodySmall: const TextStyle(color: Colors.white))),
                  child: BottomNavigationBar(
                    elevation: 0,
                   // selectedItemColor: Styles.primaryColor,
                    selectedIconTheme: const IconThemeData(
                      size: 30
                    ),
                    items:  [
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.forum),
                        label: 'Chats',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.travel_explore),
                        label: 'People',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.graphic_eq),
                        label: 'Voice',
                      ),
                      BottomNavigationBarItem(
                        icon: UserProfileIcon(
                          profileImageURL: '${BaseUrlConfig.baseUrlImage}${userLogged.user.imgProfile}',
                          genericImageURL: 'https://cdn-icons-png.flaticon.com/512/660/660611.png',
                        ),
                        label: '',
                      ),

                    ],

                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                  ),
                ),

              ],
            ),
          ),
        ),

    );
  }
}class UserProfileIcon extends StatelessWidget {
  final String profileImageURL;
  final String genericImageURL;

  const UserProfileIcon({super.key,
    required this.profileImageURL,
    required this.genericImageURL,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 19,
      backgroundImage: NetworkImage(profileImageURL),
      backgroundColor: Colors.grey,
    );
  }
}

// En tu BottomNavigationBarItem:


