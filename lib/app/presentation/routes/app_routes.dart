import 'package:ariapp/app/presentation/routes/routes.dart';
import 'package:ariapp/app/presentation/screens/home_screen.dart';
import 'package:ariapp/app/presentation/screens/profile_screen.dart';
import 'package:ariapp/app/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.home: (context) => const HomeScreen(),
    Routes.profile: (context) => const ProfileScreen(),
    Routes.settings: (context) => const SettingsScreens(),
  };
}
