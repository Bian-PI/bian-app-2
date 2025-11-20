import '../localization/app_localizations.dart';
import 'package:flutter/material.dart';

class RoleHelper {
  static String translateRole(BuildContext context, String? role) {
    final loc = AppLocalizations.of(context);
    
    if (role == null || role.isEmpty) {
      return loc.translate('role_user');
    }
    
    switch (role.toLowerCase()) {
      case 'admin':
        return loc.translate('role_admin');
      case 'user':
        return loc.translate('role_user');
      default:
        return loc.translate('role_user');
    }
  }
}