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
            radius: 20,
            backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/AriaLuxe/AriaChat/main/uploads/0743327a-ae64-4c4c-b9e1-9bed7a149e89_cf9b3928-c22e-42d7-a920-0a8e912657df_1.jpg?token=GHSAT0AAAAAACFJZURNOG4UIAC4CL4MGLFIZHOHNAA'),
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
//https://raw.githubusercontent.com/AriaLuxe/AriaChat/main/uploads/0743327a-ae64-4c4c-b9e1-9bed7a149e89_cf9b3928-c22e-42d7-a920-0a8e912657df_1.jpg?token=GHSAT0AAAAAACFJZURNOG4UIAC4CL4MGLFIZHOHNAA