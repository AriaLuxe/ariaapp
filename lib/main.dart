import 'package:ariapp/app/domain/models/users_data.dart';
import 'package:ariapp/app/presentation/screens/home_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
  /*runApp(
    DevicePreview(
      builder: (_) => MyApp(),
      enabled: true, //true para activar device preview, varios dispositivos
    ),
  );*/
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final MaterialColor myCustomColor = const MaterialColor(0xFF202248, {
    50: Color(0xFF202248),
    100: Color(0xFF202248),
    200: Color(0xFF202248),
    300: Color(0xFF202248),
    400: Color(0xFF202248),
    500: Color(0xFF202248),
    600: Color(0xFF202248),
    700: Color(0xFF202248),
    800: Color(0xFF202248),
    900: Color(0xFF202248),
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersData>(
          create: (_) => UsersData(),
        ),
      ],
      child: MaterialApp(
        builder: DevicePreview.appBuilder,
        locale: DevicePreview.locale(context),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: myCustomColor,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
