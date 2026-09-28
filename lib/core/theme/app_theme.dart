import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryRed = Color(0xFFE53935);
  static const Color darkBackground = Color(0xFF121214);
  static const Color darkCardBackground = Color(0xFF1E1E24);
  static const Color lightBackground = Color(0xFFF7F9FC);
  static const Color lightCardBackground = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryRed,
      scaffoldBackgroundColor: lightBackground,
      fontFamily: GoogleFonts.outfit().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        brightness: Brightness.light,
        surface: lightCardBackground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: lightCardBackground,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryRed,
      scaffoldBackgroundColor: darkBackground,
      fontFamily: GoogleFonts.outfit().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        brightness: Brightness.dark,
        surface: darkCardBackground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: darkCardBackground,
      ),
    );
  }
}
