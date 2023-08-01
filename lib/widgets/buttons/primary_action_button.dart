import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    super.key,
  });

  final String title;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.all(backgroundColor),
          ),
      onPressed: onPressed,
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
