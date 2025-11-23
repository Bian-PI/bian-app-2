// lib/features/auth/login_screen.dart
import 'package:bian_app/core/providers/language_provider.dart';
import 'package:bian_app/core/utils/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_service.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/user_model.dart';
import '../../core/providers/app_mode_provider.dart';
import 'register_screen.dart';
import 'email_verification_screen.dart';
import 'offline_mode_screen.dart';
import '../home/home_screen.dart';
import '../home/offline_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  final _storage = SecureStorage();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _hasConnection = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  DateTime? _lastBackPress;
@override
void initState() {
  super.initState();
  _animController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(parent: _animController, curve: Curves.easeIn),
  );
  _animController.forward();
  
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _checkInitialConnection();
  });
}

Future<void> _checkInitialConnection() async {
  print('🔍 LoginScreen: Verificando conexión inicial...');
  await Future.delayed(Duration(milliseconds: 500));
  
  final connectivityService = Provider.of<ConnectivityService>(context, listen: false);
  final hasConnection = await connectivityService.checkConnection();
  
  print('📡 LoginScreen: Conexión inicial detectada = $hasConnection');
  
  if (mounted) {
    setState(() {
      _hasConnection = hasConnection;
    });
    print('✅ LoginScreen: Estado actualizado a $_hasConnection');
  }
}

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await _apiService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        await _storage.saveToken(result['token']);

        if (result['user'] != null) {
          final user = User.fromJson(result['user']);
          await _storage.saveUser(user);
        }

        Provider.of<AppModeProvider>(context, listen: false).setLoggedIn(true);

        setState(() => _isLoading = false);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        setState(() => _isLoading = false);

        final loc = AppLocalizations.of(context);
        final message = result['message'] ?? 'invalid_credentials';

        if (message == 'user_not_verified') {
          final email = result['email'] ?? _emailController.text.trim();
          final userId = result['userId'];

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => EmailVerificationScreen(
                  email: email,
                  userId: userId,
                  fromLogin: true,
                ),
              ),
            );
          }
        } else {
          _showSnackBar(loc.translate(message), isError: true);
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      final loc = AppLocalizations.of(context);
      _showSnackBar(loc.translate('connection_error'), isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? BianTheme.errorRed : BianTheme.successGreen,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleOfflineModeClick() {
    final loc = AppLocalizations.of(context);

    if (_hasConnection) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: BianTheme.successGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.wifi,
                  color: BianTheme.successGreen,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  loc.translate('you_have_connection'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.translate('internet_connection_detected'),
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BianTheme.warningYellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: BianTheme.warningYellow.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: BianTheme.warningYellow, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        loc.translate('continue_offline_anyway') +
                            ' ' +
                            loc.translate('reports_wont_sync'),
                        style:
                            TextStyle(fontSize: 12, color: BianTheme.darkGray),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.translate('cancel')),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Provider.of<AppModeProvider>(context, listen: false)
                    .setMode(AppMode.offline);
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OfflineHomeScreen(),
                  ),
                );
              },
              icon: Icon(Icons.offline_bolt),
              label: Text(loc.translate('continue_without_connection')),
              style: ElevatedButton.styleFrom(
                backgroundColor: BianTheme.warningYellow,
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const OfflineModeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final connectivityService =
        Provider.of<ConnectivityService>(context, listen: false);

    return WillPopScope(
  onWillPop: () async {
    // Si el teclado está abierto, cerrarlo primero
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      FocusScope.of(context).unfocus();
      return false;
    }
    
    // Si no hay teclado, entonces mostrar diálogo de salida
    final now = DateTime.now();
    if (_lastBackPress == null || 
        now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
      _lastBackPress = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Presiona de nuevo para salir'),
          duration: Duration(seconds: 2),
          backgroundColor: BianTheme.mediumGray,
        ),
      );
      return false;
    }
    SystemNavigator.pop();
    return true;
  },
  child: Scaffold(
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: RefreshIndicator(
              onRefresh: () async {
                await _checkInitialConnection();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(BianTheme.paddingLarge),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 
                        MediaQuery.of(context).padding.top - 
                        MediaQuery.of(context).padding.bottom - 48,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PopupMenuButton<Locale>(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: BianTheme.lightGray,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.language,
                                    color: BianTheme.primaryRed,
                                    size: 24,
                                  ),
                                ),
                                offset: const Offset(0, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: const Locale('es'),
                                    child: Row(
                                      children: [
                                        const Text('🇪🇸',
                                            style: TextStyle(fontSize: 24)),
                                        const SizedBox(width: 12),
                                        Text(
                                          loc.translate('spanish'),
                                          style: TextStyle(
                                            fontWeight: languageProvider
                                                        .locale.languageCode ==
                                                    'es'
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: languageProvider
                                                        .locale.languageCode ==
                                                    'es'
                                                ? BianTheme.primaryRed
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: const Locale('en'),
                                    child: Row(
                                      children: [
                                        const Text('🇺🇸',
                                            style: TextStyle(fontSize: 24)),
                                        const SizedBox(width: 12),
                                        Text(
                                          loc.translate('english'),
                                          style: TextStyle(
                                            fontWeight: languageProvider
                                                        .locale.languageCode ==
                                                    'en'
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: languageProvider
                                                        .locale.languageCode ==
                                                    'en'
                                                ? BianTheme.primaryRed
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: _isLoading
                                    ? null
                                    : (Locale newLocale) {
                                        languageProvider.setLocale(newLocale);
                                      },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          Hero(
                            tag: 'bian_logo',
                            child: Image.asset(
                              'assets/images/logo2.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 24),

                          Text(
                            loc.translate('welcome'),
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: BianTheme.primaryRed,
                                ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 8),

                          Text(
                            loc.translate('login_subtitle'),
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 40),

                          TextFormField(
                            controller: _emailController,
                            enabled: !_isLoading,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: loc.translate('email_or_document'),
                              hintText: 'ejemplo@correo.com',
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return loc.translate('field_required');
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _passwordController,
                            enabled: !_isLoading,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: loc.translate('password'),
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : () => setState(
                                        () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return loc.translate('field_required');
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 32),

                          StreamBuilder<bool>(
                            stream: connectivityService.connectionStatus,
                            builder: (context, snapshot) {
                              final bool currentConnection = snapshot.hasData
                                  ? snapshot.data!
                                  : _hasConnection;

                              if (snapshot.hasData && currentConnection != _hasConnection) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (mounted) {
                                    setState(() {
                                      _hasConnection = currentConnection;
                                    });
                                  }
                                });
                              }

                              return Column(
                                children: [
                                  ElevatedButton(
                                    onPressed:
                                        (_isLoading || !currentConnection) ? null : _doLogin,
                                    child: _isLoading
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(loc.translate('signing_in')),
                                            ],
                                          )
                                        : Text(loc.translate('sign_in')),
                                  ),
                                  const SizedBox(height: 16),
                                  if (!currentConnection)
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            BianTheme.warningYellow,
                                            BianTheme.warningYellow.withOpacity(0.8),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: BianTheme.warningYellow.withOpacity(0.3),
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Icon(
                                                  Icons.offline_bolt,
                                                  color: Colors.white,
                                                  size: 28,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Sin conexión a internet',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Continúa trabajando en modo offline',
                                                      style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton.icon(
                                              onPressed: _isLoading ? null : _handleOfflineModeClick,
                                              icon: Icon(Icons.offline_bolt),
                                              label: Text('Entrar en Modo Offline'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: BianTheme.warningYellow,
                                                padding: EdgeInsets.symmetric(vertical: 12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    OutlinedButton.icon(
                                      onPressed: _isLoading ? null : _handleOfflineModeClick,
                                      icon: Icon(Icons.offline_bolt),
                                      label: Text('Modo Offline'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: BianTheme.infoBlue,
                                        side: BorderSide(color: BianTheme.infoBlue),
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                        minimumSize: Size(double.infinity, 48),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${loc.translate('no_account')} ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              StreamBuilder<bool>(
                                stream: connectivityService.connectionStatus,
                                builder: (context, snapshot) {
                                  final bool currentConnection = snapshot.hasData
                                      ? snapshot.data!
                                      : _hasConnection;

                                  return GestureDetector(
                                    onTap: (_isLoading || !currentConnection)
                                        ? null
                                        : () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => const RegisterScreen(),
                                              ),
                                            ),
                                    child: Text(
                                      loc.translate('register'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: (currentConnection && !_isLoading)
                                                ? BianTheme.primaryRed
                                                : BianTheme.mediumGray,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}