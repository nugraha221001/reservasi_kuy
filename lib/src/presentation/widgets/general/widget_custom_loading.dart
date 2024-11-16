import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0x80FFFFFF),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
