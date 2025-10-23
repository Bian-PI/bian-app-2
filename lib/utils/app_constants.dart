import 'package:flutter/material.dart';

class AppConstants {
  // Colores
  static const Color primaryColor = Color(0xFFEC1C21);
  static const Color secondaryColor = Color(0xFF00A896);
  static const Color backgroundColor = Color(0xFFF9F9F9);
  static const Color textPrimaryColor = Color(0xFF2D2D2D);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF4CAF50);

  // Dimensiones
  static const double borderRadius = 14.0;
  static const double buttonHeight = 50.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Textos
  static const String appName = 'BIAN - Bienestar Animal';

  // Rutas
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';

  // Prevenir instanciación
  AppConstants._();
}