import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color seedColor = Color(0xFF721414);

  static ThemeData light() {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      useMaterial3: true,
    );
    return base.copyWith(
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        isDense: true,
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
    return base.copyWith(
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        isDense: true,
      ),
    );
  }
}
