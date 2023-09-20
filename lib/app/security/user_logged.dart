import '../domain/entities/user_aria.dart';

class UserLogged {
  final UserAria userAria;
  final String authToken;

  UserLogged({
    required this.userAria,
    required this.authToken,
  });

  UserLogged copyWith({
    UserAria? user,
    String? authToken,
  }) =>
      UserLogged(
        userAria: userAria ?? this.userAria,
        authToken: authToken ?? this.authToken,
      );
}
