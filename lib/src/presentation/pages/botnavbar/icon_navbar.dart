import 'package:flutter/material.dart';

class IconNavBar extends StatelessWidget {
  const IconNavBar({
    super.key,
    required this.iconPath,
    required this.color,
  });

  final String iconPath;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
          child: Image.asset(
            iconPath,
            scale: 1,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}