import 'package:flutter/material.dart';

class CustomButtonFollow extends StatelessWidget {
  final String text;
  final dynamic onPressed;
  final Color color;

  const CustomButtonFollow({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = onPressed != null;

    return GestureDetector(
      onTap: isButtonEnabled ? onPressed : null,
      child: Container(
        height: 20,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isButtonEnabled
                  ? Colors.white
                  : Colors.white.withOpacity(0.36),
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
