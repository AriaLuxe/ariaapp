import 'package:ariapp/app/presentation/futures/layouts/layout.dart';
import 'package:ariapp/app/presentation/futures/sign_in/sing_in_screen.dart';
import 'package:ariapp/app/presentation/futures/sign_up/sign_up_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  splashSetup();
  runApp(const MyApp());
  /*runApp(
    DevicePreview(
      builder: (_) => MyApp(),
      enabled: true, //true para activar device preview, varios dispositivos
    ),
  );*/
}

void splashSetup() async {
  await Future.delayed(const Duration(seconds: 5));
  FlutterNativeSplash.remove();
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
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: myCustomColor,
        fontFamily: 'Lato',
      ),
      home: const SignInScreen(),
    );
  }
}
