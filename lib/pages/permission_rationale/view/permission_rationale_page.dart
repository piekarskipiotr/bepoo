import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pooapp/data/enums/app_permission.dart';
import 'package:pooapp/l10n/l10n.dart';

class PermissionRationalePage extends StatelessWidget {
  const PermissionRationalePage({required this.appPermission, super.key});

  final AppPermission appPermission;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              appPermission.rationale(context),
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                openAppSettings();
                context.pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.open_settings,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.pop(),
              child: Text(
                l10n.go_back,
                style: GoogleFonts.inter(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
