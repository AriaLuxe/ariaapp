import 'package:ariapp/app/presentation/widgets/arrow_back.dart';
import 'package:flutter/material.dart';

class HeaderFavoritesMessages extends StatelessWidget {
  const HeaderFavoritesMessages({super.key, required this.title, required this.onTap});
  final String title;

  final void Function() onTap;

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
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 20,
                color: Colors.white),
          ),
        ),
        const SizedBox(),
      ],
    );
  }
}
