import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextContentCardView extends StatelessWidget {
  const TextContentCardView({
    super.key,
    required this.name,
    required this.content,
  });

  final String name;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: GoogleFonts.openSans(fontSize: 12),
        ),
        Text(
          content,
          style: GoogleFonts.openSans(
            fontSize: 12,
          ),
        )
      ],
    );
  }
}