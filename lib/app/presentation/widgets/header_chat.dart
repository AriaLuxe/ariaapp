import 'package:flutter/material.dart';

import '../../config/styles.dart';
import 'arrow_back.dart';

class HeaderChat extends StatelessWidget {
  const HeaderChat(
      {super.key,
      required this.title,
      required this.onTap,
      required this.url,
      required this.onTapProfile});

  final String title;
  final String url;

  final void Function() onTap;
  final void Function() onTapProfile;

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
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 20,
                color: Colors.white),
          ),
        ),
        InkWell(
          onTap: onTapProfile,
          child: CircleAvatar(
            radius: 19,
            backgroundImage: NetworkImage(url),
            backgroundColor: Styles.primaryColor,
          ),
        )
      ],
    );
  }
}
