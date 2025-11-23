import 'dart:async';
import 'package:flutter/material.dart';
import '../storage/secure_storage.dart';

/// Gestiona la sesión del usuario y detecta inactividad
class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  final _storage = SecureStorage();
  Timer? _inactivityTimer;
  DateTime? _lastActivity;

  // Tiempo de inactividad antes de cerrar sesión (15 minutos)
  static const Duration inactivityTimeout = Duration(minutes: 15);

  // Callback cuando se cierra la sesión por inactividad
  VoidCallback? onSessionExpired;

  /// Iniciar monitoreo de actividad
  void startMonitoring() {
    print('📊 SessionManager: Iniciando monitoreo de inactividad');
    _lastActivity = DateTime.now();
    _resetInactivityTimer();
  }

  /// Detener monitoreo de actividad
  void stopMonitoring() {
    print('📊 SessionManager: Deteniendo monitoreo');
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
  }

  /// Registrar actividad del usuario
  void recordActivity() {
    _lastActivity = DateTime.now();
    _resetInactivityTimer();
  }

  /// Resetear el timer de inactividad
  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(inactivityTimeout, _handleInactivity);
  }

  /// Manejar cierre de sesión por inactividad
  void _handleInactivity() {
    print('⏰ SessionManager: Sesión expirada por inactividad');
    logout();
    onSessionExpired?.call();
  }

  /// Cerrar sesión (elimina token pero NO credenciales guardadas)
  Future<void> logout() async {
    print('🚪 SessionManager: Cerrando sesión');
    stopMonitoring();

    // Solo eliminar token y datos de usuario, NO credenciales guardadas
    await _storage.deleteToken();
    await _storage.deleteUser();

    _lastActivity = null;
  }

  /// Verificar si hay sesión activa
  Future<bool> hasActiveSession() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  /// Obtener tiempo desde la última actividad
  Duration? getTimeSinceLastActivity() {
    if (_lastActivity == null) return null;
    return DateTime.now().difference(_lastActivity!);
  }

  /// Tiempo restante antes de expiración
  Duration? getTimeUntilExpiration() {
    if (_lastActivity == null) return null;
    final elapsed = DateTime.now().difference(_lastActivity!);
    final remaining = inactivityTimeout - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }
}
