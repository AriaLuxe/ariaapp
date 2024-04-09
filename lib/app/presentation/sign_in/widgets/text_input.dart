import 'package:flutter/material.dart';

import '../../../config/styles.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    required this.label,
    required this.verticalPadding,
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
    this.isAnimated = FloatingLabelBehavior.never,
    this.onTap,
    this.maxLines,
    this.minLines,
  });

  final String label;
  final String? errorMessage;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool readOnly;
  final bool enabled;
  final FloatingLabelBehavior isAnimated;
  final void Function()? onTap;
  final TextInputType? textInputType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final double verticalPadding;
  final int? maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
      cursorColor: Colors.white,
      onTap: onTap,
      enabled: enabled,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: textInputType,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        fillColor: Styles.inputColor,
        floatingLabelBehavior: isAnimated,
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.white,
        ),
        suffixIcon: suffixIcon,
        hintStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFc0c0c0)),
        filled: true,
        contentPadding:
            EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 15),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Styles.inputColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Styles.inputColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        errorText: errorMessage,
      ),
    );
  }
}
