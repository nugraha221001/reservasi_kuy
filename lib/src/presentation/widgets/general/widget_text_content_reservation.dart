import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
      children: [
        Text(
          name,
          style: GoogleFonts.openSans(fontSize: 12),
        ),
        const Gap(10),
        Expanded(
          child: Text(
            content,
            style: GoogleFonts.openSans(
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.end,
          ),
        )
      ],
    );
  }
}