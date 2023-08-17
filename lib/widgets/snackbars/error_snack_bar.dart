import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bepoo/helpers/error-translator.dart';

SnackBar errorSnackbar({required BuildContext context, required String error}) {
  final errorText = ErrorTranslator.translate(
    context: context,
    error: error,
  );

  return SnackBar(
    backgroundColor: const Color(0xFFB1384E),
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(24),
      ),
    ),
    content: Row(
      children: [
        const Icon(Icons.error_outline_rounded, color: Colors.white),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              errorText,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
