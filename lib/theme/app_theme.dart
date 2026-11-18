import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color spaceDark = Color(0xFF040612);
  static const Color cardDark = Color(0xFF0F152B);
  static const Color cardBorder = Color(0xFF1E284D);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color accentPurple = Color(0xFF7C4DFF);
  static const Color accentGold = Color(0xFFFFD54F);
  static const Color textLight = Color(0xFFF0F4F8);
  static const Color textMuted = Color(0xFF8A99AD);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: spaceDark,
      primaryColor: accentCyan,
      colorScheme: const ColorScheme.dark(
        primary: accentCyan,
        secondary: accentPurple,
        surface: cardDark,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.orbitron(
          color: textLight,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        displayMedium: GoogleFonts.orbitron(
          color: textLight,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          color: textLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.spaceGrotesk(
          color: textLight,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: textLight,
          fontSize: 15,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.inter(
          color: textMuted,
          fontSize: 13,
          height: 1.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          color: textLight,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
