import 'package:flutter/material.dart';

class SignUpTextInput extends StatelessWidget {
  SignUpTextInput(
      {super.key,
      required this.title,
      this.prefixIcon,
      this.suffixIcon,
      required this.labelText});
  final String title;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String labelText;
  final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none // Cambiar el color del borde aquí

      //borderSide: BorderSide.none,
      );
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
        ),
        TextFormField(
          style: const TextStyle(color: Colors.grey),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            border: border,
            labelText: labelText,
            prefixIcon: Icon(prefixIcon),
            suffixIcon: Icon(suffixIcon),
          ),
        )
      ],
    );
  }
}
