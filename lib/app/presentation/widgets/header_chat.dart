import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/styles.dart';
import 'arrow_back.dart';

class HeaderChat extends StatelessWidget {
  HeaderChat({super.key, required this.title, required this.onTap, required this.url});
  final String title;
  final String url;

  void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ArrowBack(onTap: onTap),

        SizedBox(
          width: 200,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(

                fontSize: 20,
                color: Colors.white),
          ),
        ),
        CircleAvatar(
        radius: 19,
        backgroundImage: NetworkImage(url),
        backgroundColor: Styles.primaryColor,
    )
      ],
    );
  }
}
