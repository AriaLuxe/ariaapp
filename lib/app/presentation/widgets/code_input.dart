import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/styles.dart';

class CodeInput extends StatelessWidget {
  const CodeInput({
    super.key,
    required this.label,
    this.errorMessage,
    this.onChanged,
    this.validator,
    this.controller,
    this.textInputType,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.isAnimated = FloatingLabelBehavior.never,
  });

  final String label;
  final String? errorMessage;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool readOnly;
  final bool enabled;
  final FloatingLabelBehavior isAnimated;
  final TextInputType? textInputType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white,
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
      ],
      enabled: enabled,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: TextInputType.number,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        fillColor: Styles.inputColor,
        floatingLabelBehavior: isAnimated,
        label: Center(
          child: Text(label),
        ),
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
        alignLabelWithHint: true,
      ),
    );
  }
}
