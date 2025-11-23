import 'package:flutter/material.dart';
import '../theme/bian_theme.dart';
import '../localization/app_localizations.dart';

/// Diálogo de consentimiento para tratamiento de datos biométricos
class PrivacyConsentDialog extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const PrivacyConsentDialog({
    super.key,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: BianTheme.infoBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.fingerprint,
                    color: BianTheme.infoBlue,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    loc.translate('biometric_consent_title'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: BianTheme.darkGray,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              loc.translate('biometric_consent_message'),
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: BianTheme.darkGray,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BianTheme.warningYellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: BianTheme.warningYellow.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: BianTheme.warningYellow,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        loc.translate('important_information'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: BianTheme.darkGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBulletPoint(loc.translate('biometric_local_only')),
                  const SizedBox(height: 8),
                  _buildBulletPoint(loc.translate('biometric_device_only')),
                  const SizedBox(height: 8),
                  _buildBulletPoint(loc.translate('biometric_disable_anytime')),
                  const SizedBox(height: 8),
                  _buildBulletPoint(loc.translate('biometric_no_external_sharing')),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDecline,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: BianTheme.mediumGray,
                      side: const BorderSide(color: BianTheme.mediumGray),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(loc.translate('decline')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BianTheme.primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(loc.translate('accept_and_continue')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(fontSize: 16, height: 1.5)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
      ],
    );
  }

  /// Mostrar diálogo y retornar si aceptó o no
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PrivacyConsentDialog(
        onAccept: () => Navigator.pop(context, true),
        onDecline: () => Navigator.pop(context, false),
      ),
    );
    return result ?? false;
  }
}
