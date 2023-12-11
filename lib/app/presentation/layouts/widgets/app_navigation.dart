import 'package:ariapp/app/presentation/chats/chat/chat_screen.dart';
import 'package:ariapp/app/presentation/get_started/get_started_screen.dart';
import 'package:ariapp/app/presentation/layouts/layout.dart';
import 'package:ariapp/app/presentation/people/people_screen.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/my_information/my_information.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/my_profile_screen.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/profile_image/profile_image.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/profile_image/update_image.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/update_email/update_email.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/update_information/update_information.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/update_password/update_password.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/update_state/update_state.dart';
import 'package:ariapp/app/presentation/profiles/profile/profile_screen.dart';
import 'package:ariapp/app/presentation/sign_in/sing_in_screen.dart';
import 'package:ariapp/app/presentation/sign_up/sign_up_screen.dart';
import 'package:ariapp/app/presentation/sign_up/widgets/reset_password.dart';
import 'package:ariapp/app/presentation/sign_up/widgets/verify_code.dart';
import 'package:ariapp/app/presentation/voice/voice_screen.dart';
import 'package:ariapp/app/presentation/voice/widgets/terminos_condiciones_clone_voice_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../chats/chats_screen.dart';

class AppNavigation {
  AppNavigation._();

  static String initial = "/get_started";

  // Private navigators
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final _shellNavigatorChats =
      GlobalKey<NavigatorState>(debugLabel: 'shellChats');
  static final _shellNavigatorPeople =
      GlobalKey<NavigatorState>(debugLabel: 'shellPeople');
  static final _shellNavigatorVoice =
      GlobalKey<NavigatorState>(debugLabel: 'shellVoice');
  static final _shellNavigatorMyProfile =
      GlobalKey<NavigatorState>(debugLabel: 'shellMyProfile');

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: initial,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      /// MainWrapper
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellNavigatorChats,
            routes: [
              GoRoute(
                path: "/chats",
                name: "Chats",
                builder: (BuildContext context, GoRouterState state) =>
                    const ChatsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorPeople,
            routes: <RouteBase>[
              GoRoute(
                path: "/people",
                name: "People",
                builder: (BuildContext context, GoRouterState state) =>
                    const PeopleScreen(),
                routes: [
                  GoRoute(
                    path: "profile",
                    name: "Profile",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: ProfileScreen(
                          user: null,
                        ),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorVoice,
            routes: <RouteBase>[
              GoRoute(
                path: "/voice",
                name: "Voice",
                builder: (BuildContext context, GoRouterState state) =>
                    const VoiceScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMyProfile,
            routes: <RouteBase>[
              GoRoute(
                path: "/my_profile",
                name: "MyProfile",
                builder: (BuildContext context, GoRouterState state) {
                  return const MyProfileScreen();
                },
                routes: [
                  GoRoute(
                    path: "my_information",
                    name: "MyInformation",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const MyInformation(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                  GoRoute(
                    path: "update_information",
                    name: "UpdateInformation",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const UpdateInformation(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                  GoRoute(
                    path: "update_email",
                    name: "UpdateEmail",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const UpdateEmail(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                  GoRoute(
                    path: "update_password",
                    name: "UpdatePassword",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const UpdatePassword(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                  GoRoute(
                    path: "update_state",
                    name: "UpdateState",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const UpdateState(
                          state: '',
                        ),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                  GoRoute(
                    path: "profile_image",
                    name: "ProfileImage",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const ProfileImage(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                  GoRoute(
                    path: "update_image",
                    name: "UpdateImage",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const UpdateImage(
                          urlPhoto: '',
                        ),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/get_started',
        name: "GetStarted",
        builder: (context, state) => GetStartedScreen(
          key: state.pageKey,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/sign_in',
        name: "SignIn",
        builder: (context, state) => SignInScreen(
          key: state.pageKey,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/sign_up',
        name: "SignUp",
        builder: (context, state) => SignUpScreen(
          key: state.pageKey,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/terminos_condiciones_vc',
        name: "TerminosCondicionesVc",
        builder: (context, state) => TerminosCondicionesCloneVoiceScreen(
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/verify_code',
        name: "VerifyCode",
        builder: (context, state) {
          final Map<String, String> pathParams = state.pathParameters;

          final bool isResetPassword =
              bool.parse(pathParams['isResetPassword']!);
          final String email = pathParams['email']!;
          final String verify = pathParams['verify']!;

          return VerifyCode(
            key: state.pageKey,
            isResetPassword: isResetPassword,
            email: email,
            verify: verify,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/reset_password/:email',
        name: "ResetPassword",
        builder: (context, state) => ResetPassword(
            key: state.pageKey, email: state.uri.queryParameters['email']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/chat/:userId/:chatId/:userReceivedId',
        name: "Chat",
        builder: (context, state) {
          final userId =
              int.tryParse(state.pathParameters["userId"] ?? "0") ?? 0;
          final chatId =
              int.tryParse(state.pathParameters["chatId"] ?? "0") ?? 0;
          final userReceivedId =
              int.tryParse(state.pathParameters["userReceivedId"] ?? "0") ?? 0;

          return ChatScreen(
            key: state.pageKey,
            chatId: userId,
            userId: chatId,
            userReceivedId: userReceivedId,
          );
        },
      ),
    ],
  );
}
