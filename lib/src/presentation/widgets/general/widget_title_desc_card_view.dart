
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextTitleDescriptionCardView extends StatelessWidget {
  const TextTitleDescriptionCardView({
    super.key,
    required this.text,
    this.isTitle,
  });

  final String text;
  final bool? isTitle;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _style(isTitle ?? false),
      overflow: TextOverflow.ellipsis,
      maxLines: _maxLines(isTitle ?? false),
    );
  }

  _style(bool isTitle) {
    if (isTitle == true) {
      return GoogleFonts.openSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      );
    } else {
      return GoogleFonts.openSans(
        fontSize: 12,
      );
    }
  }

  _maxLines(bool isTitle) {
    if (isTitle == true) {
      return 2;
    } else {
      return 3;
    }
  }
}

