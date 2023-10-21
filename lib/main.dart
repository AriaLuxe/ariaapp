import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/injections.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'app/presentation/get_started/get_started_screen.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  splashSetup();
  usersDependencies();
  chatsDependencies();
  messagesDependencies();
  runApp(const MyApp());
  /*runApp(
    DevicePreview(
      builder: (_) => MyApp(),
      enabled: true, //true para activar device preview, varios dispositivos
    ),
  );*/
}

void splashSetup() async {
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        iconTheme: const IconThemeData(color: Colors.white) ,
        scaffoldBackgroundColor: Styles.primaryColor,
        appBarTheme: AppBarTheme(backgroundColor: Styles.primaryColor),
        fontFamily: 'Poppins',
      ),
      home: const GetStartedScreen(),
    );
  }
}
