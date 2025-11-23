import 'package:flutter/material.dart';
import '../theme/bian_theme.dart';

class CustomSnackbar {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
    bool isSuccess = false,
    bool isWarning = false,
    bool isInfo = false,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    Color backgroundColor;
    IconData icon;

    if (isError) {
      backgroundColor = BianTheme.errorRed;
      icon = Icons.error_outline;
    } else if (isSuccess) {
      backgroundColor = BianTheme.successGreen;
      icon = Icons.check_circle_outline;
    } else if (isWarning) {
      backgroundColor = BianTheme.warningYellow;
      icon = Icons.warning_amber_rounded;
    } else if (isInfo) {
      backgroundColor = BianTheme.infoBlue;
      icon = Icons.info_outline;
    } else {
      backgroundColor = BianTheme.darkGray;
      icon = Icons.info_outline;
    }

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, -50 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (actionLabel != null && onActionPressed != null) ...[
                    SizedBox(width: 12),
                    TextButton(
                      onPressed: () {
                        overlayEntry.remove();
                        onActionPressed();
                      },
                      child: Text(
                        actionLabel,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  static void showError(BuildContext context, String message, {Duration? duration}) {
    show(context, message, isError: true, duration: duration ?? Duration(seconds: 3));
  }

  static void showSuccess(BuildContext context, String message, {Duration? duration}) {
    show(context, message, isSuccess: true, duration: duration ?? Duration(seconds: 3));
  }

  static void showWarning(BuildContext context, String message, {Duration? duration}) {
    show(context, message, isWarning: true, duration: duration ?? Duration(seconds: 3));
  }

  static void showInfo(BuildContext context, String message, {Duration? duration}) {
    show(context, message, isInfo: true, duration: duration ?? Duration(seconds: 3));
  }
}
