import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light() => FlexThemeData.light(
        scheme: FlexScheme.espresso,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 9,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        fontFamily: GoogleFonts.inter().fontFamily,
      ).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: _textFormFieldBorder(),
          enabledBorder: _textFormFieldBorder(),
          focusedBorder: _textFormFieldBorder(),
          errorBorder: _textFormFieldBorder(),
          disabledBorder: _textFormFieldBorder(),
          filled: true,
          fillColor: const Color(0xFFEFECEC),
          contentPadding: const EdgeInsets.all(24),
        ),
      );

  static ThemeData dark() => FlexThemeData.dark(
        scheme: FlexScheme.espresso,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 15,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        fontFamily: GoogleFonts.inter().fontFamily,
      ).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: _textFormFieldBorder(),
          enabledBorder: _textFormFieldBorder(),
          focusedBorder: _textFormFieldBorder(),
          errorBorder: _textFormFieldBorder(),
          disabledBorder: _textFormFieldBorder(),
          filled: true,
          fillColor: const Color(0xFF211F1F),
          contentPadding: const EdgeInsets.all(24),
        ),
      );

  static InputBorder _textFormFieldBorder() => OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(24),
      );

  static bool isDarkMode() =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;
}
