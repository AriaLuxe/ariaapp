import 'package:flutter/material.dart';

import '../../../config/styles.dart';

class TextInput extends StatelessWidget {
  TextInput(
      {super.key,
      required this.label,
      this.errorMessage,
      this.onChanged,
      this.validator,
      this.controller,
      this.textInputType,
      this.prefixIcon,
      this.suffixIcon,
      this.obscureText = false,
      this.readOnly = false,
      this.enabled = true,
      this.isAnimated = FloatingLabelBehavior.auto,
      this.onTap});
  final String label;
  final String? errorMessage;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool readOnly;
  final bool enabled;
  final FloatingLabelBehavior isAnimated;
  void Function()? onTap;
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: Colors.grey),
  );
  final OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: Colors.red), // Cambiar el color a rojo
  );
  final TextInputType? textInputType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      enabled: enabled,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: textInputType,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        floatingLabelBehavior: isAnimated,
        prefixIcon: Icon(
          prefixIcon,
          color: Styles.primaryColor,
        ),
        suffixIcon: suffixIcon,
        hintStyle: const TextStyle(
          color: Colors.red,
          fontSize: 18,
        ),
        labelText: label,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        enabledBorder: border,
        disabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: Styles.primaryColor),
        ),
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        errorText: errorMessage,
      ),
    );
  }
}
