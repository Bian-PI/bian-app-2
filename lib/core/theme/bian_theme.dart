import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BianTheme {
  static const Color primaryRed = Color(0xFFEC1C21);
  static const Color deepRed = Color(0xFFB71C1C);
  static const Color lightRed = Color(0xFFFF5252);
  
  static const Color secondaryTeal = Color(0xFF00A896);
  static const Color accentOrange = Color(0xFFFF6F00);
  
  static const Color darkGray = Color(0xFF2D2D2D);
  static const Color mediumGray = Color(0xFF757575);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color backgroundGray = Color(0xFFF5F5F5);
  
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningYellow = Color(0xFFFFB300);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color infoBlue = Color(0xFF2196F3);
  
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  static const Color overlayDark = Color(0x80000000);
  static const Color overlayLight = Color(0x40FFFFFF);
  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, deepRed],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryTeal, Color(0xFF00796B)],
  );
  
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: primaryRed.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryRed,
        onPrimary: white,
        secondary: secondaryTeal,
        onSecondary: white,
        error: errorRed,
        onError: white,
        surface: white,
        onSurface: darkGray,
        surfaceContainerHighest: backgroundGray,
      ),
      
      scaffoldBackgroundColor: backgroundGray,
      
      appBarTheme: AppBarTheme(
        backgroundColor: primaryRed,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: white,
        ),
      ),
      
      cardTheme: CardThemeData(
        color: white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: white,
          elevation: 3,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryRed,
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        labelStyle: TextStyle(color: mediumGray),
        hintStyle: TextStyle(color: mediumGray.withOpacity(0.7)),
        errorStyle: const TextStyle(color: errorRed, fontSize: 12),
        prefixIconColor: mediumGray,
        suffixIconColor: mediumGray,
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryRed,
        foregroundColor: white,
        elevation: 6,
      ),
      
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkGray,
        contentTextStyle: GoogleFonts.poppins(color: white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 10,
      ),
      
      dividerTheme: DividerThemeData(
        color: lightGray,
        thickness: 1,
        space: 32,
      ),
      
      iconTheme: IconThemeData(
        color: mediumGray,
        size: 24,
      ),
      
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkGray,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkGray,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkGray,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkGray,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkGray,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkGray,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: darkGray,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          color: mediumGray,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          color: mediumGray,
        ),
      ),
    );
  }
  
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
}