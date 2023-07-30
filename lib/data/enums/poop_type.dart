import 'package:flutter/material.dart';
import 'package:pooapp/l10n/l10n.dart';

enum PoopType {
  hardGems,
  lumpySausage,
  cracklyLog,
  smoothSnake,
  softServe,
  mushyWaves,
  liquidExplosion,
  royal,
}

extension PoopTypeExtension on PoopType {
  String get emoji {
    switch (this) {
      case PoopType.hardGems:
        return '💎';
      case PoopType.lumpySausage:
        return '🌭';
      case PoopType.cracklyLog:
        return '🪵';
      case PoopType.smoothSnake:
        return '🐍';
      case PoopType.softServe:
        return '🍦';
      case PoopType.mushyWaves:
        return '🌊';
      case PoopType.liquidExplosion:
        return '🤯';
      case PoopType.royal:
        return '👑';
    }
  }

  String getName(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case PoopType.hardGems:
        return l10n.hard_gems_name;
      case PoopType.lumpySausage:
        return l10n.hard_lumpy_sausage_name;
      case PoopType.cracklyLog:
        return l10n.hard_crackly_log_name;
      case PoopType.smoothSnake:
        return l10n.hard_smooth_snake_name;
      case PoopType.softServe:
        return l10n.hard_soft_serve_name;
      case PoopType.mushyWaves:
        return l10n.hard_mushy_waves_name;
      case PoopType.liquidExplosion:
        return l10n.hard_liquid_explosion_name;
      case PoopType.royal:
        return l10n.hard_royal_name;
    }
  }

  String getDescription(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case PoopType.hardGems:
        return l10n.hard_gems_description;
      case PoopType.lumpySausage:
        return l10n.hard_lumpy_sausage_description;
      case PoopType.cracklyLog:
        return l10n.hard_crackly_log_description;
      case PoopType.smoothSnake:
        return l10n.hard_smooth_snake_description;
      case PoopType.softServe:
        return l10n.hard_soft_serve_description;
      case PoopType.mushyWaves:
        return l10n.hard_mushy_waves_description;
      case PoopType.liquidExplosion:
        return l10n.hard_liquid_explosion_description;
      case PoopType.royal:
        return l10n.hard_royal_description;
    }
  }
}
