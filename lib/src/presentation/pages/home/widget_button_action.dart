import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonAction extends StatelessWidget {
  const ButtonAction({
    super.key,
    required this.name,
    required this.function,
  });

  final String name;
  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      decoration: decorationBox(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: function,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Center(
              child: Text(
                name,
                style: decorationText(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  decorationBox() {
    if (name == "Terima" || name == "Selesai") {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: Colors.blueAccent,
        ),
      );
    } else {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: Colors.redAccent,
        ),
      );
    }
  }

  decorationText() {
    if (name == "Terima" || name == "Selesai") {
      return GoogleFonts.openSans(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      );
    } else {
      return GoogleFonts.openSans(
        color: Colors.redAccent,
        fontWeight: FontWeight.bold,
      );
    }
  }
}
