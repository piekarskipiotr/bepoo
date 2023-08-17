import 'package:flutter/material.dart';
import 'package:bepoo/l10n/l10n.dart';

enum AppPermission {
  camera,
  gallery,
  storage,
  location,
}

extension AppPermissionExtension on AppPermission {
  String rationale(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case AppPermission.camera:
        return l10n.permission_rationale_camera;
      case AppPermission.gallery:
        return l10n.permission_rationale_gallery;
      case AppPermission.storage:
        return l10n.permission_rationale_storage;
      case AppPermission.location:
        return l10n.permission_rationale_location;
    }
  }
}
