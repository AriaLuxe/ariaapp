import 'package:ariapp/app/presentation/futures/layouts/widgets/header.dart';
import 'package:ariapp/app/presentation/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';

import 'widgets/favorite_contacts.dart';
import 'widgets/recent_chats.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //CategorySelector(),
        Expanded(
          child: Container(
            height: 500.0,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                const Header(title: 'Chats'),
                const FavoriteContacts(),
                const CustomSearchBar(),
                RecentChats(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
