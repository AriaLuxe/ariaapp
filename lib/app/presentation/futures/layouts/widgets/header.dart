import 'package:ariapp/app/config/styles.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  const Header({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.purple,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.message,
              color: Colors.white,
            ))
      ],
    );
  }
}
