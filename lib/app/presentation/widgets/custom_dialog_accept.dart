import 'package:flutter/material.dart';

import '../../config/styles.dart';

class CustomDialogAccept extends StatelessWidget {
  final String text;
  final VoidCallback onAccept;

  const CustomDialogAccept({
    Key? key,
    required this.text,
    required this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.0),
      ),
      title: Text(text,textAlign: TextAlign.center,),
      content: ButtonBar(
        alignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: onAccept,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: const Color(0xFF354271),
              ),
              child: const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child:  Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
