import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pooapp/l10n/l10n.dart';
import 'package:pooapp/resources/resources.dart';

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.saturation,
            ),
            child: Image.asset(
              AppIcons.appIcon,
              scale: 1.1,
            ),
          ),
        ),
        Text(
          l10n.home_empty_feed,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
