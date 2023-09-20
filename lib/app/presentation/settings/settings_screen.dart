import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../config/styles.dart';
import '../../security/user_logged.dart';
import 'widgets/settings_option.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final userLogged = GetIt.instance<UserLogged>();
  static const String baseUrlImage =
      'https://uploadsaria.blob.core.windows.net/files/';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Styles.primaryColor,
          ),
          child: const Center(
            child: Text(
              'Configuración',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              '$baseUrlImage${userLogged.userAria.imgProfile}'),
                          radius: 60,
                        ),
                      ),
                      SizedBox(
                        height: 110,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userLogged.userAria.nickname,
                              style: const TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              userLogged.userAria.country,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            FilledButton(
                              onPressed: () {},
                              child: const Text('Editar Perfil'),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SettingsOption(
                          title: ' Informacion Personal',
                          icon: Icons.person,
                        ),
                        const SettingsOption(
                          title: ' Cambiar Contraseña',
                          icon: Icons.lock_open,
                        ),
                        const SettingsOption(
                          title: ' Tema',
                          icon: Icons.light_mode_outlined,
                        ),
                        const SettingsOption(
                          title: ' Privacidad',
                          icon: Icons.privacy_tip,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      ' Cerrar sesión',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
