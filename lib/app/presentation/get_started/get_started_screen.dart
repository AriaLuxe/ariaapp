import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/presentation/get_started/widgets/get_started_4.dart';
import 'package:ariapp/app/presentation/notifications/notifications_bloc.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:ariapp/injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../sign_in/sing_in_screen.dart';
import 'widgets/get_started_1.dart';
import 'widgets/get_started_2.dart';
import 'widgets/get_started_3.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  late PageController _pageController;
  bool isLoadingPage = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    checkLogin();
  }

  void checkLogin() async {
    setState(() {
      isLoadingPage = true;
    });
    final usersRepository = GetIt.instance<UserAriaRepository>();
    int? userId = await SharedPreferencesManager.getUserId();

    String? token = await SharedPreferencesManager.getToken();
    bool? hasSeenGetStarted =
        await SharedPreferencesManager.getHasSeenGetStarted();
    await Future.delayed(const Duration(seconds: 3));
    context.read<NotificationsBloc>().requestPermission();

    if (hasSeenGetStarted == null || hasSeenGetStarted == false) {
      setState(() {
        isLoadingPage = false;
      });
      SharedPreferencesManager.saveHasSeenGetStarted(true);

      return;
    } else {
      if (token != null) {
        final user = await usersRepository.getUserById(userId!);
        userLogged(user);
        setState(() {
          isLoadingPage = false;
        });
        // Si hay un token, navega a la pantalla principal
        context.go('/chats');
      } else {
        setState(() {
          isLoadingPage = false;
        });
        // Si no hay un token, navega a la pantalla de inicio de sesión
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }
    }
    setState(() {
      isLoadingPage = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  void navigateToPage(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoadingPage
          ? Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: Image.asset(
                          'assets/images/tree_oficial.png',
                          key: const ValueKey<String>(
                              'assets/images/tree_oficial.png'),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Image.asset(
                          'assets/images/aia.png',
                          key: const ValueKey<String>('assets/images/aia.png'),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    ],
                  ),
                ),
              ],
            )
          : PageView(
              allowImplicitScrolling: false,
              controller: _pageController,
              children: [
                  GetStarted1(onPress: () {
                    navigateToPage(1);
                  }),
                  GetStarted2(onBack: () {
                    navigateToPage(0);
                  }, onPress: () {
                    navigateToPage(2);
                  }),
                  GetStarted3(onBack: () {
                    navigateToPage(1);
                  }, onPress: () {
                    navigateToPage(3);
                  }),
                  GetStarted4(
                      onBack: () {
                        navigateToPage(2);
                      },
                      onPress: () {}())
                ]),
    );
  }
}
