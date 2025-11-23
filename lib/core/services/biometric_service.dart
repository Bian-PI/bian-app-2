import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import '../storage/secure_storage.dart';

/// Servicio para autenticación biométrica (huella/Face ID)
class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();
  final _storage = SecureStorage();

  // Keys para SharedPreferences
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _rememberAccountKey = 'remember_account';
  static const String _savedEmailKey = 'saved_email';

  /// Verificar si el dispositivo soporta biometría
  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print('❌ Error verificando soporte biométrico: $e');
      return false;
    }
  }

  /// Obtener tipos de biometría disponibles
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('❌ Error obteniendo biometría disponible: $e');
      return [];
    }
  }

  /// Verificar si tiene huella o Face ID disponible
  Future<bool> hasBiometricCapability() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.isNotEmpty;
  }

  /// Autenticar con biometría
  Future<bool> authenticate({
    required String reason,
    bool useErrorDialogs = true,
  }) async {
    try {
      final isSupported = await isDeviceSupported();
      if (!isSupported) {
        print('⚠️ Dispositivo no soporta biometría');
        return false;
      }

      final hasCapability = await hasBiometricCapability();
      if (!hasCapability) {
        print('⚠️ No hay biometría configurada en el dispositivo');
        return false;
      }

      return await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: true,
          biometricOnly: false, // Permite PIN como fallback
        ),
      );
    } on PlatformException catch (e) {
      print('❌ Error en autenticación biométrica: $e');
      return false;
    }
  }

  /// Verificar si la biometría está habilitada para esta cuenta
  Future<bool> isBiometricEnabled() async {
    return await _storage.getBiometricEnabled();
  }

  /// Habilitar autenticación biométrica
  Future<void> enableBiometric() async {
    await _storage.saveBiometricEnabled(true);
    print('✅ Biometría habilitada');
  }

  /// Deshabilitar autenticación biométrica
  Future<void> disableBiometric() async {
    await _storage.saveBiometricEnabled(false);
    print('🔒 Biometría deshabilitada');
  }

  /// Guardar credenciales para "Recordar cuenta"
  Future<void> saveRememberedAccount(String email, String password) async {
    await _storage.saveRememberAccount(true);
    await _storage.saveSavedEmail(email);
    await _storage.saveSavedPassword(password); // Guardado de forma segura
    print('💾 Cuenta guardada para recordar');
  }

  /// Eliminar credenciales guardadas
  Future<void> clearRememberedAccount() async {
    await _storage.saveRememberAccount(false);
    await _storage.deleteSavedEmail();
    await _storage.deleteSavedPassword();
    print('🗑️ Cuenta eliminada de memoria');
  }

  /// Verificar si "Recordar cuenta" está activado
  Future<bool> isRememberAccountEnabled() async {
    return await _storage.getRememberAccount();
  }

  /// Obtener email guardado
  Future<String?> getSavedEmail() async {
    return await _storage.getSavedEmail();
  }

  /// Obtener credenciales completas (requiere autenticación biométrica)
  Future<Map<String, String>?> getSavedCredentials() async {
    final email = await _storage.getSavedEmail();
    final password = await _storage.getSavedPassword();

    if (email == null || password == null) return null;

    return {
      'email': email,
      'password': password,
    };
  }

  /// Obtener nombre del tipo de biometría
  String getBiometricTypeName(List<BiometricType> biometrics) {
    if (biometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return 'Huella Digital';
    } else if (biometrics.contains(BiometricType.iris)) {
      return 'Iris';
    }
    return 'Biometría';
  }
}
