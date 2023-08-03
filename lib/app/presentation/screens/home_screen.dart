/*import 'package:ariapp/app/presentation/screens/messages_screen.dart';
import 'package:ariapp/app/presentation/screens/people_screen.dart';
import 'package:ariapp/app/presentation/screens/settings_screen.dart';
//import 'package:ariapp/app/presentation/widgets/category_selector.dart';
import 'package:ariapp/app/presentation/widgets/favorite_contacts.dart';
import 'package:ariapp/app/presentation/widgets/recent_chats.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final List<String> categories = ['Mensajes', 'Personas', 'Configuracion'];

  // Define las rutas para cada sección
  final Map<String, Widget> routes = {
    'Mensajes': MessagesScreen(),
    'Personas': PeopleScreen(),
    'Configuracion': SettingsScreens(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(0xFF202248), //Theme.of(context).primaryColor, //Colors.red

      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 120,
        elevation: 0.0, //quita el sombreado inferior del appbar
        title: Padding(
          padding: const EdgeInsets.only(top: 50, left: 0, bottom: 10),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu),
                    iconSize: 30.0,
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  Text(
                    'Chats',
                    //textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                height: 90.0,
                color: Theme.of(context).primaryColor,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });

                          // Obtén el nombre de la categoría seleccionada
                          String categoryName = categories[index];

                          // Obtén la ruta asociada a la categoría seleccionada
                          Widget? route = routes[categoryName];

                          // Navega a la ruta correspondiente
                          if (route != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => route),
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 20, top: 10),
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: index == selectedIndex
                                  ? Colors.white
                                  : Colors.white60,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0, //espacio entre las letras
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),

      body: IndexedStack(
        index: selectedIndex,
        children: routes.values.toList(),
      ),

      /*Column(children: [
        //CategorySelector(),
        Expanded(
          child: Container(
            height: 500.0,
            decoration: BoxDecoration(
              color: Colors.white,
              //Color(0xFF5D62F2), //const Color.fromARGB(255, 255, 247, 223),
              /*Theme.of(context).accentColor*/
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                FavoriteContacts(),
                RecentChats(),
              ],
            ),
          ),
        ),
      ]),*/
    );
  }
}*/

import 'package:ariapp/app/presentation/screens/messages_screen.dart';
import 'package:ariapp/app/presentation/screens/people_screen.dart';
import 'package:ariapp/app/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final List<String> categories = ['Mensajes', 'Personas', 'Configuracion'];

  // Define las rutas para cada sección
  final Map<String, Widget> routes = {
    'Mensajes': const MessagesScreen(),
    'Personas': const PeopleScreen(),
    'Configuracion': const SettingsScreens(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202248),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 120,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(top: 50, left: 0, bottom: 10),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    iconSize: 30.0,
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  const Text(
                    'Chats',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                height: 90.0,
                color: Theme.of(context).primaryColor,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, top: 10),
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: index == selectedIndex
                                ? Colors.white
                                : Colors.white60,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: routes.values.toList(),
      ),
    );
  }
}
