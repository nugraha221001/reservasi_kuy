import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleSubtitleDetailPage extends StatelessWidget {
  const TitleSubtitleDetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    this.isTitle,
    this.noSub,
    this.noTitle,
  });

  final String title, subtitle;
  final bool? isTitle, noSub, noTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(),
          _subtitle(),
        ],
      ),
    );
  }

  _isTitle() {
    if (isTitle != null) {
      if (isTitle == true) {
        return GoogleFonts.openSans(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        );
      } else {
        return GoogleFonts.openSans(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        );
      }
    } else {
      return GoogleFonts.openSans(
        fontWeight: FontWeight.w700,
        fontSize: 14,
      );
    }
  }

  _title() {
    if (noTitle != null) {
      if (noTitle == true) {
        return const SizedBox();
      } else {
        return Text(
          title,
          style: _isTitle(),
        );
      }
    } else {
      return Text(
        title,
        style: _isTitle(),
      );
    }
  }

  _subtitle() {
    if (noSub != null) {
      if (noSub == true) {
        return const SizedBox();
      } else {
        return Text(
          subtitle,
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        );
      }
    } else {
      return Text(
        subtitle,
        style: GoogleFonts.openSans(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      );
    }
  }
}
