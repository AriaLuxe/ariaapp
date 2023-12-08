import 'package:ariapp/app/config/styles.dart';
import 'package:flutter/material.dart';

class CustomButtonVoiceClone extends StatelessWidget {
  final String text;
  final dynamic onPressed;
  final double width;

  const CustomButtonVoiceClone({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = onPressed != null;

    return GestureDetector(
      onTap: isButtonEnabled ? onPressed : null,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 100,
            ),
          ],
          color: Styles.primaryColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isButtonEnabled
                  ? Colors.white
                  : Colors.white.withOpacity(0.36),
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
