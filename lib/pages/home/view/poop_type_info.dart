import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pooapp/data/enums/poop_type.dart';
import 'package:pooapp/widgets/buttons/outlined_action_button.dart';

class PoopTypeInfo extends StatefulWidget {
  const PoopTypeInfo({required this.poopType, super.key});

  final PoopType poopType;

  @override
  State<PoopTypeInfo> createState() => _PoopTypeInfoState();
}

class _PoopTypeInfoState extends State<PoopTypeInfo> {
  late PoopType _poopType;
  bool _showDescription = false;

  @override
  void initState() {
    super.initState();
    _poopType = widget.poopType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        bottom: 16,
        right: 72,
      ),
      alignment: Alignment.bottomLeft,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: Column(
          key: ValueKey<bool>(_showDescription),
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: OutlinedActionButton(
                onPressed: () => setState(
                  () => _showDescription = !_showDescription,
                ),
                title: '${_poopType.emoji} ${_poopType.getName(context)}',
                textColor: Colors.white,
                borderColor: Colors.white,
              ),
            ),
            if (_showDescription) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  _poopType.getDescription(context),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
