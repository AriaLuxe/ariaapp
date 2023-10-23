import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ArrowBack extends StatelessWidget {
  const ArrowBack({super.key, this.onTap});
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0), // Espacio entre el ícono y el borde
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF354271), // Color de fondo del ícono
        ),
        child: const Icon(
          Icons.arrow_back_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
