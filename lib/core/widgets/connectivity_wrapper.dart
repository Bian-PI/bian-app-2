// lib/core/widgets/connectivity_wrapper.dart - NUEVO ARCHIVO
import 'package:bian_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/connectivity_service.dart';
import '../providers/app_mode_provider.dart';
import '../theme/bian_theme.dart';
import '../../features/auth/offline_mode_screen.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  bool _hasShownOfflineDialog = false;

  @override
  Widget build(BuildContext context) {
    final connectivityService = Provider.of<ConnectivityService>(context, listen: false);
    final appModeProvider = Provider.of<AppModeProvider>(context, listen: false);

    return StreamBuilder<bool>(
      stream: connectivityService.connectionStatus,
      builder: (context, snapshot) {
        final hasConnection = snapshot.data ?? true;

        // Si está en modo online y pierde conexión
        if (!hasConnection && 
            appModeProvider.isLoggedIn && 
            !appModeProvider.isOfflineMode && 
            !_hasShownOfflineDialog) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showConnectionLostDialog(context);
          });
        }

        return Stack(
          children: [
            widget.child,
            if (!hasConnection)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildConnectionBanner(),
              ),
          ],
        );
      },
    );
  }

// lib/core/widgets/connectivity_wrapper.dart - ACTUALIZAR TRADUCCIONES

Widget _buildConnectionBanner() {
  return Container(
    color: BianTheme.errorRed,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: SafeArea(
      bottom: false,
      child: Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Sin conexión a internet', // Podría usar loc.translate('no_connection')
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void _showConnectionLostDialog(BuildContext context) {
  if (_hasShownOfflineDialog) return;
  _hasShownOfflineDialog = true;

  final loc = AppLocalizations.of(context);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: BianTheme.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.wifi_off,
                color: BianTheme.errorRed,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                loc.translate('connection_lost'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Se ha perdido la conexión a internet.',
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
                  Icon(Icons.info_outline, color: BianTheme.warningYellow, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      loc.translate('session_closed_for_security'),
                      style: TextStyle(fontSize: 12, color: BianTheme.darkGray),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _hasShownOfflineDialog = false;
            },
            child: Text(loc.translate('wait')),
          ),
          ElevatedButton(
            onPressed: () async {
              final appModeProvider = Provider.of<AppModeProvider>(context, listen: false);
              await appModeProvider.logout();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const OfflineModeScreen()),
                  (route) => false,
                );
              }
              _hasShownOfflineDialog = false;
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: BianTheme.warningYellow,
            ),
            child: Text(loc.translate('offline_mode')),
          ),
        ],
      ),
    ),
  );
}
}