import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash/splash_screen.dart';
import 'features/auth/views/login_screen.dart';
import 'features/home/views/home_screen.dart';

void main() {
  runApp(const BianApp());
}

class BianApp extends StatelessWidget {
  const BianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BIAN - Bienestar Animal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00A896)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A896),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            minimumSize: const Size(double.infinity, 50),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
      },
      home: const SplashScreen(),
    );
  }
}
