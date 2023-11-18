import 'package:flutter/material.dart';

import '../../config/styles.dart';

class CustomDialog extends StatelessWidget {
  final String text;
  final VoidCallback onOk;
  final VoidCallback onCancel;

  const CustomDialog({
    Key? key,
    required this.text,
    required this.onOk,
    required this.onCancel,
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
            onTap: onCancel,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: const Color(0xFF354271),
              ),
              child: const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child:  Text(
                  'No',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onOk,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: const Color(0xFF354271),
              ),
              child: const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child:  Text(
                  'Sí',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
