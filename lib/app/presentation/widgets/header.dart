import 'package:flutter/material.dart';

import 'arrow_back.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.title, required this.onTap});

  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ArrowBack(onTap: onTap),
        SizedBox(
          width: 200,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          ),
        ),
        Image.asset(
          'assets/images/tree_oficial.png',
          width: 42,
        ),
      ],
    );
  }
}
