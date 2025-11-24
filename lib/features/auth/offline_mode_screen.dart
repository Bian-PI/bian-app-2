
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/app_mode_provider.dart';
import '../home/offline_home_screen.dart';

class OfflineModeScreen extends StatelessWidget {
  const OfflineModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              BianTheme.mediumGray.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: BianTheme.warningYellow.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: 120,
                    color: BianTheme.warningYellow,
                  ),
                ),

                const SizedBox(height: 40),

                Text(
                  loc.translate('offline_mode_screen_title'),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: BianTheme.darkGray,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                Text(
                  loc.translate('no_internet_detected'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: BianTheme.mediumGray,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: BianTheme.infoBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: BianTheme.infoBlue.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: BianTheme.infoBlue,
                        size: 32,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        loc.translate('what_can_do_offline'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: BianTheme.darkGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(
                        icon: Icons.add_circle_outline,
                        text: loc.translate('create_new_evaluations'),
                      ),
                      _buildFeatureItem(
                        icon: Icons.save_outlined,
                        text: loc.translate('save_reports_locally'),
                      ),
                      _buildFeatureItem(
                        icon: Icons.picture_as_pdf_outlined,
                        text: loc.translate('generate_pdfs'),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: BianTheme.warningYellow.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: BianTheme.warningYellow,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                loc.translate('offline_reports_warning'),
                                style: TextStyle(
                                  fontSize: 11,
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

                const SizedBox(height: 40),

                ElevatedButton.icon(
                  onPressed: () {
                    Provider.of<AppModeProvider>(context, listen: false)
                        .setMode(AppMode.offline);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OfflineHomeScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.offline_bolt),
                  label: Text(loc.translate('continue_without_connection')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BianTheme.warningYellow,
                    minimumSize: const Size(double.infinity, 56),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: BianTheme.successGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: BianTheme.darkGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}