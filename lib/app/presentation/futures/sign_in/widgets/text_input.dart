import 'package:flutter/material.dart';

import '../../../../config/styles.dart';

class TextInput extends StatelessWidget {
  TextInput({
    super.key,
    required this.label,
    this.errorMessage,
    this.onChanged,
    this.validator,
    this.controller,
    this.textInputType,
    this.prefixIcon,
    required this.isPassword,
    this.suffixIcon,
  });
  final String label;
  final String? errorMessage;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: Colors.grey),
  );
  final TextInputType? textInputType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  final bool isPassword;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: textInputType,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIcon,
          color: Styles.primaryColor,
        ),
        suffixIcon: Icon(
          suffixIcon,
          color: Styles.primaryColor,
        ),
        hintStyle: const TextStyle(
          color: Colors.red,
          fontSize: 18,
        ),
        labelText: label,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: Styles.primaryColor),
        ),
        errorBorder: border.copyWith(
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorText: errorMessage,
      ),
    );
  }
}
