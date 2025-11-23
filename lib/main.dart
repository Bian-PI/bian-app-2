import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/providers/language_provider.dart';
import 'core/providers/app_mode_provider.dart';
import 'core/utils/connectivity_service.dart';
import 'core/services/session_manager.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/bian_theme.dart';
import 'core/widgets/custom_snackbar.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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

    // Configurar callback de sesión expirada
    _sessionManager.onSessionExpired = _handleSessionExpired;
  }

  @override
  void dispose() {
    _sessionManager.stopMonitoring();
    super.dispose();
  }

  void _handleSessionExpired() {
    print('⏰ Sesión expirada, redirigiendo a login...');

    // Navegar a login
    _navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );

    // Mostrar mensaje
    Future.delayed(const Duration(milliseconds: 500), () {
      final context = _navigatorKey.currentContext;
      if (context != null && mounted) {
        CustomSnackbar.showWarning(
          context,
          AppLocalizations.of(context).translate('session_expired_message'),
          duration: const Duration(seconds: 5),
        );
      }
    });
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