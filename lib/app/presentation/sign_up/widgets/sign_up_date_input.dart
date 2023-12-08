import 'package:flutter/material.dart';

class SignUpDateInput extends StatelessWidget {
  SignUpDateInput(
      {super.key,
      required this.title,
      this.suffixIcon,
      required this.labelText});

  final String title;
  final IconData? suffixIcon;
  final String labelText;
  final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none);

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
            contentPadding: const EdgeInsets.all(5),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            border: border,
            labelText: labelText,
          ),
        )
      ],
    );
  }
}
