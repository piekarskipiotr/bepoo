import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pooapp/data/enums/poop_type.dart';
import 'package:pooapp/l10n/l10n.dart';
import 'package:pooapp/pages/poost_creation/bloc/poost_creation_bloc.dart';
import 'package:pooapp/widgets/app_choice_chip.dart';

class PoopTypeSelection extends StatefulWidget {
  const PoopTypeSelection({super.key});

  @override
  State<PoopTypeSelection> createState() => _PoopTypeSelectionState();
}

class _PoopTypeSelectionState extends State<PoopTypeSelection> {
  int? _selectedItem;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.poop_type,
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                PoopType.values.length,
                (index) {
                  final poopType = PoopType.values[index];
                  return AppChoiceChip(
                    title: '${poopType.emoji} ${poopType.getName(context)}',
                    isSelected: _selectedItem == index,
                    onSelected: (selected) {
                      setState(() {
                        _selectedItem = selected ? index : null;
                        context.read<PoostCreationBloc>().poopType =
                            selected ? PoopType.values[index] : null;
                      });
                    },
                  );
                },
              ).toList(),
            ),
          ),
          if (_selectedItem != null) ...[
            const SizedBox(height: 8),
            Text(
              PoopType.values[_selectedItem!].getDescription(context),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
