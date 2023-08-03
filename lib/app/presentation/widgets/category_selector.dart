import 'package:ariapp/app/presentation/screens/home_screen.dart';
import 'package:ariapp/app/presentation/screens/people_screen.dart';
import 'package:ariapp/app/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CategorySelector> {
  int selectedIndex = 0;
  final List<String> categories = ['Mensajes', 'Personas', 'Configuracion'];

  // Define las rutas para cada sección
  final Map<String, Widget> routes = {
    'Mensajes': const HomeScreen(),
    'Personas': const PeopleScreen(),
    'Configuracion': const SettingsScreens(),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
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
                String categoryName = categories[index];
                Widget? route = routes[categoryName];
                if (route != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => route),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 30.0,
                ),
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color:
                        index == selectedIndex ? Colors.white : Colors.white60,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
