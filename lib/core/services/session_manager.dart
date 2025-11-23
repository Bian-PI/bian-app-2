import 'dart:async';
import 'package:flutter/material.dart';
import '../storage/secure_storage.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  final _storage = SecureStorage();
  Timer? _inactivityTimer;
  DateTime? _lastActivity;

  static const Duration inactivityTimeout = Duration(minutes: 15);

  VoidCallback? onSessionExpired;

  void startMonitoring() {
    print('📊 SessionManager: Iniciando monitoreo de inactividad');
    _lastActivity = DateTime.now();
    _resetInactivityTimer();
  }

  void stopMonitoring() {
    print('📊 SessionManager: Deteniendo monitoreo');
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
  }

  void recordActivity() {
    _lastActivity = DateTime.now();
    _resetInactivityTimer();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(inactivityTimeout, _handleInactivity);
  }

  void _handleInactivity() {
    print('⏰ SessionManager: Sesión expirada por inactividad');
    logout();
    onSessionExpired?.call();
  }

  Future<void> logout() async {
    print('🚪 SessionManager: Cerrando sesión');
    stopMonitoring();

    await _storage.deleteToken();
    await _storage.deleteUser();

    _lastActivity = null;
  }

  Future<bool> hasActiveSession() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  Duration? getTimeSinceLastActivity() {
    if (_lastActivity == null) return null;
    return DateTime.now().difference(_lastActivity!);
  }

  Duration? getTimeUntilExpiration() {
    if (_lastActivity == null) return null;
    final elapsed = DateTime.now().difference(_lastActivity!);
    final remaining = inactivityTimeout - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }
}
