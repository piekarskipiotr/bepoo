import 'package:bepoo/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendsEmptyList extends StatelessWidget {
  const FriendsEmptyList({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            AppIcons.appIcon,
            scale: 1.1,
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
