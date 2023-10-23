import 'package:flutter/material.dart';

import 'arrow_back.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ArrowBack(onTap: (){
          Navigator.pop(context);
        },),
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
