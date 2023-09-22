import 'package:ariapp/app/presentation/settings/settings_screen.dart';
import 'package:ariapp/app/presentation/voice/voice_screen.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/styles.dart';
import '../chats/chat_list/bloc/chat_list_bloc.dart';
import '../chats/chats_screen.dart';
import '../people/people_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatListBloc(),
      child: Scaffold(
        backgroundColor: Styles.primaryColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: DotNavigationBar(
            paddingR: const EdgeInsets.symmetric(vertical: 8),
            dotIndicatorColor: Colors.white,
            unselectedItemColor: Colors.grey[300],
            splashBorderRadius: 50,
            backgroundColor: Styles.primaryColor,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            onTap: (value) {
              setState(() {
                currentPageIndex = value;
                pageController.animateToPage(
                  value,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                );
              });
            },
            currentIndex: currentPageIndex,
            items: [
              DotNavigationBarItem(
                icon: const Icon(
                  Icons.message_outlined,
                  color: Colors.white,
                ),
                selectedColor: Styles.primaryColor,
              ),
              DotNavigationBarItem(
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                selectedColor: Styles.primaryColor,
              ),
              DotNavigationBarItem(
                icon: const Icon(
                  Icons.voice_chat,
                  color: Colors.white,
                ),
                selectedColor: Styles.primaryColor,
              ),
              DotNavigationBarItem(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                selectedColor: Styles.primaryColor,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: PageView(
            controller: pageController,
            onPageChanged: (value) {
              setState(() {
                currentPageIndex = value;
              });
            },
            children: [
              const ChatsScreen(),
              const PeopleScreen(),
              const VoiceScreen(),
              SettingsScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
