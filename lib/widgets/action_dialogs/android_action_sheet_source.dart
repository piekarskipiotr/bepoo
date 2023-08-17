import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bepoo/l10n/l10n.dart';

class AndroidActionSheetSource extends StatelessWidget {
  const AndroidActionSheetSource({
    required this.onCameraPressed,
    required this.onGalleryPressed,
    super.key,
  });

  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        ListTile(
          onTap: () {
            onCameraPressed();
            Navigator.pop(context);
          },
          leading: const Icon(Icons.camera_alt),
          title: Text(l10n.open_camera, style: GoogleFonts.inter()),
        ),
        const Divider(height: 1),
        ListTile(
          onTap: () {
            onGalleryPressed();
            Navigator.pop(context);
          },
          leading: const Icon(Icons.image),
          title: Text(l10n.open_gallery, style: GoogleFonts.inter()),
        ),
      ],
    );
  }
}
