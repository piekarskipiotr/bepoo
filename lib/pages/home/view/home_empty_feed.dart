import 'package:bepoo/l10n/l10n.dart';
import 'package:bepoo/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeEmptyFeed extends StatelessWidget {
  const HomeEmptyFeed({super.key});

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
