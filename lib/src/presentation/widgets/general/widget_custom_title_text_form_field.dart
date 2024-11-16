import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTitleTextFormField extends StatelessWidget {
  const CustomTitleTextFormField({
    super.key,
    required this.subtitle,
  });

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      style: GoogleFonts.openSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}