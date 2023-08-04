import 'package:ariapp/app/config/styles.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  const Header({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: CircleAvatar(
            backgroundColor: Colors.purple,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.message,
              color: Styles.primaryColor,
            ))
      ],
    );
  }
}
