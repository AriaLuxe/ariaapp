import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/presentation/chats/chat/bloc/chat_bloc.dart';
import 'package:ariapp/app/presentation/chats/chat_list/bloc/chat_list_bloc.dart';
import 'package:ariapp/app/presentation/layouts/layout.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/update_information/update_information.dart';
import 'package:ariapp/injections.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/presentation/get_started/get_started_screen.dart';
import 'app/presentation/layouts/widgets/app_navigation.dart';

void main() {
  usersDependencies();
  chatsDependencies();
  messagesDependencies();
  voiceDependencies();
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ChatListBloc(),
          ),
        BlocProvider(
            create: (context) => ChatBloc(),
          ),
      ],
      child: MaterialApp.router(
        title: 'Aia',
        routerConfig: AppNavigation.router,
        builder: DevicePreview.appBuilder,
        locale: DevicePreview.locale(context),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          iconTheme: const IconThemeData(color: Colors.white),
          scaffoldBackgroundColor: Styles.primaryColor,
          appBarTheme: AppBarTheme(backgroundColor: Styles.primaryColor),
          fontFamily: 'Poppins',
        ),
        //home: const GetStartedScreen(),
      ),
    );
  }
}
