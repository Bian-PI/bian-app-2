import 'package:bian_app/core/providers/language_provider.dart';
import 'package:bian_app/core/utils/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_service.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/storage/local_reports_storage.dart';
import '../../core/services/biometric_service.dart';
import '../../core/services/session_manager.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/user_model.dart';
import '../../core/providers/app_mode_provider.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../../core/widgets/privacy_consent_dialog.dart';
import 'register_screen.dart';
import 'email_verification_screen.dart';
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
  final _biometricService = BiometricService();
  final _sessionManager = SessionManager();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _hasConnection = false;
  bool _rememberAccount = false;
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  String? _biometricType;
  int _pendingReportsCount = 0;

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Cargar lo crítico primero
      await Future.wait([
        _checkInitialConnection(),
        _loadSavedCredentials(),
      ]);

      // Luego cargar lo secundario solo si es necesario
      if (_rememberAccount) {
        _checkBiometricAvailability();
      }

      // Cargar reportes pendientes de forma lazy (no bloquea la UI)
      _loadPendingReportsCount();
    });
  }

  Future<void> _checkInitialConnection() async {
    print('🔍 LoginScreen: Verificando conexión inicial...');

    final connectivityService =
        Provider.of<ConnectivityService>(context, listen: false);
    final hasConnection = await connectivityService.checkConnection();

    print('📡 LoginScreen: Conexión inicial detectada = $hasConnection');

    if (mounted) {
      setState(() {
        _hasConnection = hasConnection;
      });
      print('✅ LoginScreen: Estado actualizado a $_hasConnection');
    }
  }

  Future<void> _loadSavedCredentials() async {
    final rememberEnabled = await _biometricService.isRememberAccountEnabled();
    final savedEmail = await _biometricService.getSavedEmail();
    final biometricEnabled = await _biometricService.isBiometricEnabled();

    if (mounted) {
      setState(() {
        _rememberAccount = rememberEnabled;
        _biometricEnabled = biometricEnabled;
        if (savedEmail != null) {
          _emailController.text = savedEmail;
        }
      });

      if (savedEmail != null) {
        print('✅ Credenciales cargadas: $savedEmail');
        print('🔐 Biometría habilitada: $biometricEnabled');
        print('💾 Recordar cuenta: $rememberEnabled');
      } else {
        print('ℹ️ No hay credenciales guardadas');
      }
    }
  }

  Future<void> _checkBiometricAvailability() async {
    final isAvailable = await _biometricService.hasBiometricCapability();
    if (isAvailable) {
      final biometrics = await _biometricService.getAvailableBiometrics();
      final typeName = _biometricService.getBiometricTypeName(biometrics);

      if (mounted) {
        setState(() {
          _biometricAvailable = true;
          _biometricType = typeName;
        });
        print('✅ Biometría disponible: $typeName');
      }
    }
  }

  Future<void> _loadPendingReportsCount() async {
    final count = await LocalReportsStorage.getPendingSyncCount();
    if (mounted) {
      setState(() {
        _pendingReportsCount = count;
      });
      print('📊 Reportes pendientes de sincronización: $count');
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

          // Migrar reportes offline al usuario que acaba de logearse
          final migratedCount = await LocalReportsStorage.migrateOfflineReportsToUser(user.id?? 0);
          if (migratedCount > 0) {
            print('✅ Login: Migrados $migratedCount reportes offline al usuario ${user.email}');
          }
        }

        if (_rememberAccount) {
          await _biometricService.saveRememberedAccount(
            _emailController.text.trim(),
            _passwordController.text,
          );
          print('💾 Credenciales guardadas');
        }

        Provider.of<AppModeProvider>(context, listen: false).setLoggedIn(true);

        _sessionManager.startMonitoring();

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

  Future<void> _loginWithBiometric() async {
    print('🔐 Iniciando login con biometría...');

    if (!_biometricEnabled) {
      print('❌ Biometría no habilitada');
      CustomSnackbar.showWarning(
        context,
        'La autenticación biométrica no está habilitada',
      );
      return;
    }

    final loc = AppLocalizations.of(context);

    // Primero verificar que hay credenciales guardadas
    final credentials = await _biometricService.getSavedCredentials();
    if (credentials == null) {
      print('❌ No hay credenciales guardadas');
      CustomSnackbar.showError(context, 'No hay credenciales guardadas para este dispositivo');
      return;
    }

    print('✅ Credenciales encontradas para: ${credentials['email']}');

    // Solicitar autenticación biométrica
    print('👆 Solicitando autenticación biométrica...');
    final authenticated = await _biometricService.authenticate(
      reason: loc.translate('authenticate_with', [_biometricType ?? 'Biometría']),
    );

    if (!authenticated) {
      print('❌ Autenticación biométrica fallida o cancelada');
      CustomSnackbar.showError(context, 'Autenticación biométrica fallida');
      return;
    }

    print('✅ Autenticación biométrica exitosa');
    setState(() => _isLoading = true);

    try {
      print('📡 Haciendo login con credenciales guardadas...');
      final result = await _apiService.login(
        credentials['email']!,
        credentials['password']!,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        print('✅ Login exitoso con biometría');
        await _storage.saveToken(result['token']);

        if (result['user'] != null) {
          final user = User.fromJson(result['user']);
          await _storage.saveUser(user);

          // Migrar reportes offline al usuario que acaba de logearse
          final migratedCount = await LocalReportsStorage.migrateOfflineReportsToUser(user.id?? 0);
          if (migratedCount > 0) {
            print('✅ Login biométrico: Migrados $migratedCount reportes offline al usuario ${user.email}');
          }
        }

        Provider.of<AppModeProvider>(context, listen: false).setLoggedIn(true);
        _sessionManager.startMonitoring();

        setState(() => _isLoading = false);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        print('❌ Login fallido: ${result['message']}');
        setState(() => _isLoading = false);
        _showSnackBar(loc.translate('invalid_credentials'), isError: true);
      }
    } catch (e) {
      print('❌ Error en login biométrico: $e');
      setState(() => _isLoading = false);
      _showSnackBar(loc.translate('connection_error'), isError: true);
    }
  }

  Future<void> _toggleRememberAccount(bool value) async {
    if (value) {
      // Verificar disponibilidad de biometría si aún no se ha verificado
      if (!_biometricAvailable) {
        await _checkBiometricAvailability();
      }

      // Si la biometría está disponible, solicitar consentimiento
      if (_biometricAvailable) {
        final accepted = await PrivacyConsentDialog.show(context);
        if (!accepted) return;

        setState(() {
          _rememberAccount = true;
          _biometricEnabled = true;
        });

        await _biometricService.enableBiometric();
        CustomSnackbar.showSuccess(
          context,
          'Biometría activada. Inicia sesión para guardar tus credenciales.',
        );
      } else {
        // Si no hay biometría disponible, solo marcar remember account
        setState(() => _rememberAccount = true);
      }
    } else {
      setState(() {
        _rememberAccount = false;
        _biometricEnabled = false;
      });
      await _biometricService.disableBiometric();
      await _biometricService.clearRememberedAccount();
      _passwordController.clear();
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (isError) {
      CustomSnackbar.showError(context, message);
    } else {
      CustomSnackbar.showSuccess(context, message);
    }
  }

  void _handleOfflineModeClick() {
    Provider.of<AppModeProvider>(context, listen: false)
        .setMode(AppMode.offline);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const OfflineHomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final connectivityService =
        Provider.of<ConnectivityService>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        if (MediaQuery.of(context).viewInsets.bottom > 0) {
          FocusScope.of(context).unfocus();
          return false;
        }

        final now = DateTime.now();
        if (_lastBackPress == null ||
            now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
          _lastBackPress = now;
          CustomSnackbar.showInfo(
            context,
            loc.translate('press_again_to_exit'),
            duration: Duration(seconds: 2),
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
                        MediaQuery.of(context).padding.bottom -
                        48,
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
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
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

                          const SizedBox(height: 24),

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

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Checkbox(
                                value: _rememberAccount,
                                onChanged: _isLoading
                                    ? null
                                    : (value) => _toggleRememberAccount(value ?? false),
                                activeColor: BianTheme.primaryRed,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: _isLoading
                                      ? null
                                      : () => _toggleRememberAccount(!_rememberAccount),
                                  child: Text(
                                    loc.translate('remember_account'),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              if (_rememberAccount && _biometricAvailable)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: BianTheme.infoBlue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.fingerprint,
                                        color: BianTheme.infoBlue,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _biometricType ?? 'Biometría',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: BianTheme.infoBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          StreamBuilder<bool>(
                            stream: connectivityService.connectionStatus,
                            builder: (context, snapshot) {
                              final bool currentConnection = snapshot.hasData
                                  ? snapshot.data!
                                  : _hasConnection;

                              if (snapshot.hasData &&
                                  currentConnection != _hasConnection) {
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
                                    onPressed: (_isLoading || !currentConnection)
                                        ? null
                                        : _doLogin,
                                    child: _isLoading
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
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

                                  if (_biometricEnabled &&
                                      !_isLoading &&
                                      currentConnection)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: OutlinedButton.icon(
                                        onPressed: _loginWithBiometric,
                                        icon: const Icon(Icons.fingerprint),
                                        label: Text(
                                            loc.translate('biometric_login')),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              BianTheme.infoBlue,
                                          side: const BorderSide(
                                            color: BianTheme.infoBlue,
                                            width: 2,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          minimumSize:
                                              const Size(double.infinity, 52),
                                        ),
                                      ),
                                    ),

                                  const SizedBox(height: 16),
                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: BianTheme.lightGray,
                                  ),
                                  const SizedBox(height: 16),

                                  OutlinedButton.icon(
                                    onPressed: _isLoading
                                        ? null
                                        : _handleOfflineModeClick,
                                    icon: Icon(Icons.offline_bolt),
                                    label:
                                        Text(loc.translate('continue_offline')),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: currentConnection
                                          ? BianTheme.infoBlue
                                          : BianTheme.warningYellow,
                                      side: BorderSide(
                                        color: currentConnection
                                            ? BianTheme.infoBlue
                                            : BianTheme.warningYellow,
                                        width: 2,
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 14),
                                      minimumSize:
                                          Size(double.infinity, 52),
                                    ),
                                  ),

                                  if (_pendingReportsCount > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: _buildPendingReportsBanner(loc),
                                    ),

                                  if (!currentConnection)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.wifi_off,
                                              size: 16,
                                              color: BianTheme.warningYellow),
                                          const SizedBox(width: 8),
                                          Text(
                                            loc.translate(
                                                'no_internet_connection'),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: BianTheme.warningYellow,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
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
                              GestureDetector(
                                onTap: (_isLoading || !_hasConnection)
                                    ? null
                                    : () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const RegisterScreen(),
                                          ),
                                        ),
                                child: Text(
                                  loc.translate('register'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: (_hasConnection && !_isLoading)
                                            ? BianTheme.primaryRed
                                            : BianTheme.mediumGray,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
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

  Widget _buildPendingReportsBanner(AppLocalizations loc) {
    return InkWell(
      onTap: _isLoading ? null : _handleOfflineModeClick,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: BianTheme.successGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: BianTheme.successGreen.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_upload,
              color: BianTheme.successGreen,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              '$_pendingReportsCount pendiente${_pendingReportsCount == 1 ? "" : "s"}',
              style: TextStyle(
                color: BianTheme.darkGray,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: BianTheme.successGreen,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
