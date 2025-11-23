import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <-- Nuevo

import 'core/providers/language_provider.dart';
import 'core/providers/app_mode_provider.dart';
import 'core/utils/connectivity_service.dart';
import 'core/services/session_manager.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/bian_theme.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🟩 Cargar variables desde el archivo .env
  await dotenv.load(fileName: ".env");

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
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

class BianApp extends StatefulWidget {
  const BianApp({super.key});

  @override
  State<BianApp> createState() => _BianAppState();
}

class _BianAppState extends State<BianApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();

    print("GEMINI_API_KEY: ${dotenv.env['GEMINI_API_KEY']}");
    print("API_BASE_URL: ${dotenv.env['API_BASE_URL']}");
    print("MAIL_SERVICE_URL: ${dotenv.env['MAIL_SERVICE_URL']}");
  }

  @override
  void dispose() {
    _sessionManager.stopMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
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
