import 'package:flutter/material.dart';

class FavoriteContacts extends StatelessWidget {
  const FavoriteContacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Favorite Contacts',
                  style: TextStyle(
                      color: Color(0xFF202248),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      letterSpacing: 1.0),
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
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 35.0,
                          backgroundColor: Colors.red,
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        Text(
                          'favorites[index].name',
                          style: const TextStyle(
                            color: Color(0xFF202248),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
