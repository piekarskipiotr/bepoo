import 'package:flutter/material.dart';
import 'package:bepoo/resources/resources.dart';

enum SignInMethod { google, apple }

extension SignInMethodExtension on SignInMethod {
  String get logo {
    switch (this) {
      case SignInMethod.google:
        return SignInIcons.google;
      case SignInMethod.apple:
        return SignInIcons.apple;
    }
  }

  Color get btnBgColor {
    switch (this) {
      case SignInMethod.google:
        return Colors.white;
      case SignInMethod.apple:
        return Colors.black;
    }
  }

  Color get btnTxtColor {
    switch (this) {
      case SignInMethod.google:
        return Colors.black;
      case SignInMethod.apple:
        return Colors.white;
    }
  }

  ColorFilter? get logoColorFilter {
    switch (this) {
      case SignInMethod.google:
        return null;
      case SignInMethod.apple:
        return const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        );
    }
  }

  String get name {
    switch (this) {
      case SignInMethod.google:
        return 'Google';
      case SignInMethod.apple:
        return 'Apple';
    }
  }
}
