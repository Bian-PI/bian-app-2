import 'package:bian_app/core/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_service.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/user_model.dart';
import 'register_screen.dart';
import 'email_verification_screen.dart';
import '../home/home_screen.dart';

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
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

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
      // Guardar token
      await _storage.saveToken(result['token']);
      
      // Guardar usuario
      if (result['user'] != null) {
        final user = User.fromJson(result['user']);
        await _storage.saveUser(user);
      }

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
        final userId = result['userId']; // ✅ Capturar userId
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => EmailVerificationScreen(
                email: email,
                userId: userId, // ✅ Pasar userId
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

@override
Widget build(BuildContext context) {
  final loc = AppLocalizations.of(context);
  final languageProvider = Provider.of<LanguageProvider>(context);
  
  return Scaffold(
    body: SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(BianTheme.paddingLarge),
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
                              const Text('🇪🇸', style: TextStyle(fontSize: 24)),
                              const SizedBox(width: 12),
                              Text(
                                'Español',
                                style: TextStyle(
                                  fontWeight: languageProvider.locale.languageCode == 'es'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: languageProvider.locale.languageCode == 'es'
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
                              const Text('🇺🇸', style: TextStyle(fontSize: 24)),
                              const SizedBox(width: 12),
                              Text(
                                'English',
                                style: TextStyle(
                                  fontWeight: languageProvider.locale.languageCode == 'en'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: languageProvider.locale.languageCode == 'en'
                                      ? BianTheme.primaryRed
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: _isLoading ? null : (Locale newLocale) {
                        languageProvider.setLocale(newLocale);
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                  // Logo
                  Hero(
                    tag: 'bian_logo',
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Título
                  Text(
                    loc.translate('welcome'),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: BianTheme.primaryRed,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Subtítulo
                  Text(
                    loc.translate('login_subtitle'),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Email/Document
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
                  
                  // Password
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
                            : () => setState(() => _obscurePassword = !_obscurePassword),
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
                  
                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _doLogin,
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
                  
                  const SizedBox(height: 20),
                  
                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${loc.translate('no_account')} ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                ),
                        child: Text(
                          loc.translate('register'),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: BianTheme.primaryRed,
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
    );
  }
}