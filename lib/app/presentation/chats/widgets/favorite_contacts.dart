import 'package:flutter/material.dart';

class FavoriteContacts extends StatelessWidget {
  const FavoriteContacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Contactos Favoritos',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.more_horiz,
                ),
                iconSize: 30.0,
                color: const Color(0xFF202248),
                onPressed: () {},
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120.0,
          child: ListView.builder(
              padding: const EdgeInsets.only(left: 10.0),
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return /*GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(user: favorites[]),
                      ),
                    ),*/
                    Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35.0,
                        backgroundColor: Colors.yellow,
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        'name',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        )
      ],
    );
    ;
  }
}