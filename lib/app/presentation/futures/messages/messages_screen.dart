import 'package:flutter/material.dart';

import '../chats/widgets/favorite_contacts.dart';
import '../chats/widgets/recent_chats.dart';

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
                const FavoriteContacts(),
                RecentChats(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
