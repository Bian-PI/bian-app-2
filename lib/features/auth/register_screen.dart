import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/api/api_service.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/utils/validators.dart';
import '../../core/localization/app_localizations.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _documentController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _apiService = ApiService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _documentController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _doRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await _apiService.register({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'document': _documentController.text.trim(),
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text,
      });

      if (!mounted) return;

      setState(() => _isLoading = false);

      final loc = AppLocalizations.of(context);

      if (result['success'] == true) {
        // Mostrar diálogo de verificación
        _showVerificationDialog();
      } else {
        final message = result['message'] ?? 'server_error';
        _showSnackBar(loc.translate(message), isError: true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      final loc = AppLocalizations.of(context);
      _showSnackBar(loc.translate('connection_error'), isError: true);
    }
  }

  void _showVerificationDialog() {
    final loc = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.mark_email_read, color: BianTheme.primaryRed),
            SizedBox(width: 12),
            Text(loc.translate('verify_account_title')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.email_outlined,
              size: 64,
              color: BianTheme.secondaryTeal,
            ),
            SizedBox(height: 16),
            Text(
              loc.translate('verify_account_message'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              _emailController.text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: BianTheme.primaryRed,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: Text(loc.translate('accept')),
          ),
        ],
      ),
    );
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: BianTheme.primaryRed),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(BianTheme.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                
                const SizedBox(height: 16),
                
                // Título
                Text(
                  loc.translate('register'),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: BianTheme.primaryRed,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  loc.translate('register_subtitle'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Nombre Completo
                TextFormField(
                  controller: _nameController,
                  enabled: !_isLoading,
                  textCapitalization: TextCapitalization.words,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(Validators.nameMaxLength),
                  ],
                  decoration: InputDecoration(
                    labelText: loc.translate('full_name'),
                    hintText: 'Juan Pérez',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    final error = Validators.validateFullName(value);
                    return error != null ? loc.translate(error) : null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Email
                TextFormField(
                  controller: _emailController,
                  enabled: !_isLoading,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(Validators.emailMaxLength),
                  ],
                  decoration: InputDecoration(
                    labelText: loc.translate('email'),
                    hintText: 'ejemplo@correo.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    final error = Validators.validateEmail(value);
                    return error != null ? loc.translate(error) : null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Documento
                TextFormField(
                  controller: _documentController,
                  enabled: !_isLoading,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(Validators.documentMaxLength),
                  ],
                  decoration: InputDecoration(
                    labelText: loc.translate('document'),
                    hintText: '1234567890',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (value) {
                    final error = Validators.validateDocument(value);
                    return error != null ? loc.translate(error) : null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Teléfono
                TextFormField(
                  controller: _phoneController,
                  enabled: !_isLoading,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(Validators.phoneMaxLength),
                  ],
                  decoration: InputDecoration(
                    labelText: loc.translate('phone'),
                    hintText: '3001234567',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (value) {
                    final error = Validators.validatePhone(value);
                    return error != null ? loc.translate(error) : null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Contraseña
                TextFormField(
                  controller: _passwordController,
                  enabled: !_isLoading,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: loc.translate('password'),
                    prefixIcon: Icon(Icons.lock_outline),
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
                    final error = Validators.validatePassword(value);
                    return error != null ? loc.translate(error) : null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Confirmar Contraseña
                TextFormField(
                  controller: _confirmPasswordController,
                  enabled: !_isLoading,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: loc.translate('confirm_password'),
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: _isLoading
                          ? null
                          : () => setState(
                              () => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                  validator: (value) {
                    final error = Validators.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    );
                    return error != null ? loc.translate(error) : null;
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Botón Registrar
                ElevatedButton(
                  onPressed: _isLoading ? null : _doRegister,
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(loc.translate('registering')),
                          ],
                        )
                      : Text(loc.translate('sign_up')),
                ),
                
                const SizedBox(height: 20),
                
                // Link a Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${loc.translate('have_account')} ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              ),
                      child: Text(
                        loc.translate('login'),
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
    );
  }
}