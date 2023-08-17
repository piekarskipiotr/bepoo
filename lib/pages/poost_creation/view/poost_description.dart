import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bepoo/l10n/l10n.dart';
import 'package:bepoo/pages/poost_creation/bloc/poost_creation_bloc.dart';

class PoostDescription extends StatefulWidget {
  const PoostDescription({super.key});

  @override
  State<PoostDescription> createState() => _PoostDescriptionState();
}

class _PoostDescriptionState extends State<PoostDescription> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.description} (${l10n.optional})',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            onChanged: (desc) =>
                context.read<PoostCreationBloc>().description = desc,
            maxLines: 4,
            maxLength: 255,
            decoration: InputDecoration(
              hintText: l10n.description_hint,
              hintStyle: GoogleFonts.inter(),
            ),
          ),
        ],
      ),
    );
  }
}
