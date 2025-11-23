import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import '../storage/secure_storage.dart';

class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();
  final _storage = SecureStorage();


  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print('❌ Error verificando soporte biométrico: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('❌ Error obteniendo biometría disponible: $e');
      return [];
    }
  }

  Future<bool> hasBiometricCapability() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.isNotEmpty;
  }

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
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      print('❌ Error en autenticación biométrica: $e');
      return false;
    }
  }

  Future<bool> isBiometricEnabled() async {
    return await _storage.getBiometricEnabled();
  }

  Future<void> enableBiometric() async {
    await _storage.saveBiometricEnabled(true);
    print('✅ Biometría habilitada');
  }

  Future<void> disableBiometric() async {
    await _storage.saveBiometricEnabled(false);
    print('🔒 Biometría deshabilitada');
  }

  Future<void> saveRememberedAccount(String email, String password) async {
    await _storage.saveRememberAccount(true);
    await _storage.saveSavedEmail(email);
    await _storage.saveSavedPassword(password);
    print('💾 Cuenta guardada para recordar');
  }

  Future<void> clearRememberedAccount() async {
    await _storage.saveRememberAccount(false);
    await _storage.deleteSavedEmail();
    await _storage.deleteSavedPassword();
    print('🗑️ Cuenta eliminada de memoria');
  }

  Future<bool> isRememberAccountEnabled() async {
    return await _storage.getRememberAccount();
  }

  Future<String?> getSavedEmail() async {
    return await _storage.getSavedEmail();
  }

  Future<Map<String, String>?> getSavedCredentials() async {
    final email = await _storage.getSavedEmail();
    final password = await _storage.getSavedPassword();

    if (email == null || password == null) return null;

    return {
      'email': email,
      'password': password,
    };
  }

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
