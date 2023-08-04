import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/presentation/futures/layouts/widgets/header.dart';
import 'package:ariapp/app/presentation/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';

import 'widgets/favorite_contacts.dart';
import 'widgets/chats_list.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //CategorySelector(),
        Container(
          // Ajusta la altura según tu diseño
          decoration: BoxDecoration(
            color: Styles.primaryColor, // Color de fondo morado
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          child: const Column(
            children: [
              Header(title: 'Chats'),
            ],
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
            child: Column(
              children: [
                FavoriteContacts(),
                ChatsList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
