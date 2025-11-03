import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/api/api_service.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import 'login_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final int? userId;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    this.userId,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _apiService = ApiService();
  bool _isResending = false;
  bool _canResend = false;
  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _canResend = false;
      _countdown = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  Future<void> _resendEmail() async {
    if (!_canResend || _isResending || widget.userId == null) return;

    setState(() => _isResending = true);

    try {
      final result = await _apiService.resendVerificationEmail(
        widget.userId!,
        widget.email,
      );

      if (!mounted) return;

      final loc = AppLocalizations.of(context);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(loc.translate('verification_sent')),
                ),
              ],
            ),
            backgroundColor: BianTheme.successGreen,
          ),
        );
        _startCountdown();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(loc.translate('server_error')),
                ),
              ],
            ),
            backgroundColor: BianTheme.errorRed,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.translate('connection_error')),
          backgroundColor: BianTheme.errorRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  void _goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async => false, // Evitar que salgan con back button
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                BianTheme.primaryRed.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(BianTheme.paddingLarge),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Icono grande de email
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: BianTheme.primaryRed.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.mark_email_read_outlined,
                      size: 120,
                      color: BianTheme.primaryRed,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Título
                  Text(
                    loc.translate('verify_account_title'),
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: BianTheme.primaryRed,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Mensaje principal
                  Text(
                    loc.translate('check_email'),
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Email destacado
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: BianTheme.primaryRed.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.email,
                          color: BianTheme.primaryRed,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            widget.email,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: BianTheme.primaryRed,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Instrucciones
                  _buildInstructionCard(
                    icon: Icons.looks_one,
                    title: loc.translate('step_1_title'),
                    description: loc.translate('step_1_description'),
                  ),

                  const SizedBox(height: 16),

                  _buildInstructionCard(
                    icon: Icons.looks_two,
                    title: loc.translate('step_2_title'),
                    description: loc.translate('step_2_description'),
                  ),

                  const SizedBox(height: 16),

                  _buildInstructionCard(
                    icon: Icons.looks_3,
                    title: loc.translate('step_3_title'),
                    description: loc.translate('step_3_description'),
                  ),

                  const SizedBox(height: 40),

                  // Botón reenviar
                  ElevatedButton.icon(
                    onPressed: _canResend && !_isResending ? _resendEmail : null,
                    icon: _isResending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(
                      _canResend
                          ? loc.translate('resend_verification')
                          : '${loc.translate('resend_in')} $_countdown${loc.translate('seconds')}',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canResend
                          ? BianTheme.primaryRed
                          : BianTheme.mediumGray,
                      minimumSize: const Size(double.infinity, 52),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Botón ir a login
                  OutlinedButton.icon(
                    onPressed: _goToLogin,
                    icon: const Icon(Icons.login),
                    label: Text(loc.translate('go_to_login')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: BianTheme.primaryRed,
                      side: const BorderSide(color: BianTheme.primaryRed),
                      minimumSize: const Size(double.infinity, 52),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Aviso importante
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: BianTheme.warningYellow.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: BianTheme.warningYellow.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: BianTheme.warningYellow,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            loc.translate('check_spam_folder'),
                            style: const TextStyle(
                              fontSize: 12,
                              color: BianTheme.darkGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: BianTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: BianTheme.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: BianTheme.primaryRed,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: BianTheme.mediumGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}