// lib/core/providers/app_mode_provider.dart
import 'package:flutter/material.dart';
import '../storage/secure_storage.dart';

enum AppMode { online, offline }

class AppModeProvider extends ChangeNotifier {
  AppMode _mode = AppMode.online;
  bool _isLoggedIn = false;
  
  AppMode get mode => _mode;
  bool get isLoggedIn => _isLoggedIn;
  bool get isOfflineMode => _mode == AppMode.offline;

  Future<void> initialize() async {
    final storage = SecureStorage();
    _isLoggedIn = await storage.hasActiveSession();
    notifyListeners();
  }

  void setMode(AppMode mode) {
    _mode = mode;
    notifyListeners();
  }

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  Future<void> logout() async {
    final storage = SecureStorage();
    await storage.clearAll();
    _isLoggedIn = false;
    notifyListeners();
  }
}