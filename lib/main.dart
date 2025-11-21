// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/providers/language_provider.dart';
import 'core/providers/app_mode_provider.dart';
import 'core/utils/connectivity_service.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/bian_theme.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  final connectivityService = ConnectivityService();
  await connectivityService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AppModeProvider()..initialize()),
        Provider<ConnectivityService>.value(value: connectivityService),
      ],
      child: const BianApp(),
    ),
  );
}

class BianApp extends StatelessWidget {
  const BianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'BIAN - Bienestar Animal',
          debugShowCheckedModeBanner: false,
          
          locale: languageProvider.locale,
          supportedLocales: const [
            Locale('es'),
            Locale('en'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          
          theme: BianTheme.lightTheme,
          
          home: const SplashScreen(),
        );
      },
    );
  }
}