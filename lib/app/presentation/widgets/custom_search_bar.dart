import 'package:flutter/material.dart';

import '../../config/styles.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key, this.onChanged, required this.title});
  final Function(String)? onChanged;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: Styles.inputColor,
          filled: true,

          enabledBorder:  OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Styles.inputColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                color: Styles.inputColor,
              )),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.symmetric(vertical: 3.0),
          labelText: title,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          labelStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
