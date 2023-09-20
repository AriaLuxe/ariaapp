import 'package:ariapp/app/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../security/user_logged.dart';
import '../../settings/settings_screen.dart';

class Header extends StatelessWidget {
  final String title;
  final IconData iconData;
  final void Function()? onPressed;
  Header(
      {super.key, required this.title, required this.iconData, this.onPressed});

  final userLogged = GetIt.instance<UserLogged>();
  static const String baseUrlImage =
      'https://uploadsaria.blob.core.windows.net/files/';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  '$baseUrlImage${userLogged.userAria.imgProfile}'),
            ),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        IconButton(
            onPressed: onPressed,
            icon: Icon(
              iconData,
              color: Colors.white,
            ))
      ],
    );
  }
}
