import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pooapp/l10n/l10n.dart';
import 'package:pooapp/widgets/app_bar_icon.dart';

class PoostCreationPage extends StatefulWidget {
  const PoostCreationPage({super.key});

  @override
  State<PoostCreationPage> createState() => _PoostCreationPageState();
}

class _PoostCreationPageState extends State<PoostCreationPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(top: 56),
      child: Scaffold(
        appBar: _appBar(context),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    final l10n = context.l10n;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        l10n.add_poost,
        style: GoogleFonts.inter(),
      ),
      leadingWidth: 64,
      leading: AppBarIcon(
        onPressed: () => context.pop(),
        icon: Icons.close,
        isLeading: true,
      ),
    );
  }
}
