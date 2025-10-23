import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash/splash_screen.dart';
import 'features/auth/views/login_screen.dart';
import 'features/home/views/home_screen.dart';
import 'utils/app_constants.dart';

void main() {
  runApp(const BianApp());
}

class BianApp extends StatelessWidget {
  const BianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.primaryColor),
        useMaterial3: true,
        scaffoldBackgroundColor: AppConstants.backgroundColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            minimumSize: Size(double.infinity, AppConstants.buttonHeight),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      routes: {
        AppConstants.loginRoute: (_) => const LoginScreen(),
        AppConstants.homeRoute: (_) => const HomeScreen(),
      },
      home: const SplashScreen(),
    );
  }
}