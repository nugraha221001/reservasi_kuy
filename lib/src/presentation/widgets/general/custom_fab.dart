import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({
    super.key,
    required this.iconData,
    required this.function,
  });

  final VoidCallback function;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
          border: Border.all(
            width: 1,
            color: Colors.blueAccent.shade400,
          )),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(90),
          splashColor: Colors.blueAccent.withOpacity(0.4),
          onTap: function,
          child:  Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              iconData,
              size: 28,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
    );
  }
}
