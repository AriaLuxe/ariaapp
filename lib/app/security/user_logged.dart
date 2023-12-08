import '../domain/entities/user_aria.dart';

class UserLogged {
  UserAria user;

  UserLogged({
    required this.user,
  });

  UserLogged copyWith({
    UserAria? user,
  }) =>
      UserLogged(
        user: user ?? this.user,
      );
}
