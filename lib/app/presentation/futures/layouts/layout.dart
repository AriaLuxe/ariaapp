import 'package:ariapp/app/presentation/futures/chats/chats_list_screen.dart';
import 'package:ariapp/app/presentation/futures/settings/settings_screen.dart';
import 'package:flutter/material.dart';

import '../people/people_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {});
            currentPageIndex = value;
            print(currentPageIndex);
          },
          currentIndex: currentPageIndex,
          // onDestinationSelected: (int index) {
          //  setState(() {
          //   currentPageIndex = index;
          // });
          // },
          //selectedIndex: currentPageIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined), label: 'Chats'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Personas'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Configuración'),
          ]),
      body: SafeArea(
        child: <Widget>[
          const MessagesScreen(),
          const PeopleScreen(),
          const SettingsScreens()
        ][currentPageIndex],
      ),
    );
  }
}
