import 'package:bepoo/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ErrorTranslator {
  static String translate({
    required BuildContext context,
    required String error,
  }) {
    final l10n = context.l10n;

    if (error.contains('name-empty')) {
      return l10n.user_name_empty;
    } else if (error.contains('name-already-exists')) {
      return l10n.user_name_taken;
    } else {
      return error;
    }
  }
}