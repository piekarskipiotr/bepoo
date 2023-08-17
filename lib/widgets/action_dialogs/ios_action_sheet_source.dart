import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bepoo/l10n/l10n.dart';

class IOSActionSheetSource extends StatelessWidget {
  const IOSActionSheetSource({
    required this.onCameraPressed,
    required this.onGalleryPressed,
    super.key,
  });

  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CupertinoActionSheet(
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          onPressed: () {
            onCameraPressed();
            Navigator.pop(context);
          },
          child: Text(l10n.open_camera, style: GoogleFonts.inter()),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            onGalleryPressed();
            Navigator.pop(context);
          },
          child: Text(l10n.open_gallery),
        ),
      ],
    );
  }
}
