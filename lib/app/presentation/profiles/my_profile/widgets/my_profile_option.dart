import 'package:flutter/material.dart';

class MyProfileOption extends StatelessWidget {
  const MyProfileOption({super.key, required this.icon, required this.title, required this.onTap});
  final IconData icon;
  final String title;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      leading:  Icon(icon, color: Colors.white,size: 27,),
      tileColor: const Color(0xFF354271).withOpacity(0.97),
      textColor: Colors.white,
      title:  Text(title),
      trailing: const Icon(Icons.arrow_forward_ios,color: Colors.white,),
      onTap: onTap,
    );
  }
}
