import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OutlinedActionButton extends StatelessWidget {
  const OutlinedActionButton({
    required this.title,
    required this.onPressed,
    this.borderColor,
    this.textColor,
    super.key,
  });

  final String title;
  final VoidCallback onPressed;
  final Color? borderColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
        side: MaterialStateBorderSide.resolveWith((states) {
          return BorderSide(color: borderColor ?? Colors.white);
        }),
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
