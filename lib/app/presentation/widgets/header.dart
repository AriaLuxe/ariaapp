import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'arrow_back.dart';

class Header extends StatelessWidget {
   Header({super.key, required this.title, required this.onTap});
  final String title;
  void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ArrowBack(onTap: onTap),
         Padding(
          padding:  const EdgeInsets.only(top: 25.0),
          child:  SizedBox(
            width: 200,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white),
            ),
          ),
        ),
        Image.asset('assets/images/logo-aia.jpg',width: 60,),
      ],
    );
  }
}
