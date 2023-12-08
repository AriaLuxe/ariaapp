import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final dynamic onPressed;
  final double width;

  const CustomButton({
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
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: isButtonEnabled
                ? [const Color(0xFF9269BE), const Color(0xFF5368D6)]
                : [
                    const Color(0xFF9269BE).withOpacity(0.36),
                    const Color(0xFF5368D6).withOpacity(0.36)
                  ], // Color gris para botón bloqueado
          ),
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
