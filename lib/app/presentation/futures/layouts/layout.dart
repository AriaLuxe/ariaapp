import 'package:ariapp/app/presentation/futures/chats/chats_screen.dart';
import 'package:ariapp/app/presentation/futures/settings/settings_screen.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../../config/styles.dart';
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
      backgroundColor: Styles.primaryColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: DotNavigationBar(
            paddingR: const EdgeInsets.symmetric(vertical: 15),
            dotIndicatorColor: Colors.white,
            unselectedItemColor: Colors.grey[300],
            splashBorderRadius: 50,
            backgroundColor: Styles.primaryColor,
            margin: const EdgeInsets.only(left: 10, right: 10),
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
            items: [
              DotNavigationBarItem(
                  icon: const Icon(
                    Icons.message_outlined,
                    color: Colors.white,
                  ),
                  selectedColor: Styles.primaryColor),
              DotNavigationBarItem(
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  selectedColor: Styles.primaryColor),
              DotNavigationBarItem(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  selectedColor: Styles.primaryColor),
            ]),
      ),
      body: SafeArea(
        child: <Widget>[
          const ChatsScreen(),
          const PeopleScreen(),
          const SettingsScreens()
        ][currentPageIndex],
      ),
    );
  }
}
