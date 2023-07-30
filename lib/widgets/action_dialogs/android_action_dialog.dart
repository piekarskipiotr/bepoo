import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AndroidActionDialog extends StatelessWidget {
  const AndroidActionDialog({
    required this.title,
    required this.subtitle,
    required this.primaryText,
    required this.secondaryText,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    super.key,
  });

  final String title;
  final String subtitle;
  final String primaryText;
  final String secondaryText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: GoogleFonts.inter(),
      ),
      content: Text(
        subtitle,
        style: GoogleFonts.inter(),
      ),
      actions: [
        ElevatedButton(
          onPressed: onPrimaryPressed,
          child: Text(
            primaryText,
            style: GoogleFonts.inter(),
          ),
        ),
        TextButton(
          onPressed: onSecondaryPressed,
          child: Text(
            secondaryText,
            style: GoogleFonts.inter(),
          ),
        ),
      ],
    );
  }
}
