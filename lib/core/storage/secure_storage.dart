import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/user_model.dart';

class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;
  SecureStorage._internal();

  final _storage = const FlutterSecureStorage();

  static const String _keyToken = 'jwt_token';
  static const String _keyUser = 'user_data';
  static const String _keyUserId = 'user_id';
  static const String _keyIsVerified = 'is_verified';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyRememberAccount = 'remember_account';
  static const String _keySavedEmail = 'saved_email';
  static const String _keySavedPassword = 'saved_password';

  
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  
  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: _keyUser, value: userJson);
    if (user.id != null) {
      await _storage.write(key: _keyUserId, value: user.id.toString());
    }
    await _storage.write(
      key: _keyIsVerified,
      value: user.isActiveSession.toString(),
    );
  }

  Future<User?> getUser() async {
    final userJson = await _storage.read(key: _keyUser);
    if (userJson == null) return null;
    
    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  Future<int?> getUserId() async {
    final id = await _storage.read(key: _keyUserId);
    if (id == null) return null;
    return int.tryParse(id);
  }

  Future<bool> isUserVerified() async {
    final verified = await _storage.read(key: _keyIsVerified);
    return verified == 'true';
  }

  Future<void> setUserVerified(bool verified) async {
    await _storage.write(key: _keyIsVerified, value: verified.toString());
  }

  
  Future<bool> hasActiveSession() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  
  Future<void> saveSession({
    required String token,
    required User user,
  }) async {
    await saveToken(token);
    await saveUser(user);
  }

  Future<Map<String, dynamic>> getSessionData() async {
    final token = await getToken();
    final user = await getUser();
    final isVerified = await isUserVerified();

    return {
      'token': token,
      'user': user,
      'isVerified': isVerified,
      'hasSession': token != null,
    };
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: _keyUser);
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyIsVerified);
  }


  Future<void> saveBiometricEnabled(bool enabled) async {
    await _storage.write(key: _keyBiometricEnabled, value: enabled.toString());
  }

  Future<bool> getBiometricEnabled() async {
    final value = await _storage.read(key: _keyBiometricEnabled);
    return value == 'true';
  }

  Future<void> saveRememberAccount(bool remember) async {
    await _storage.write(key: _keyRememberAccount, value: remember.toString());
  }

  Future<bool> getRememberAccount() async {
    final value = await _storage.read(key: _keyRememberAccount);
    return value == 'true';
  }

  Future<void> saveSavedEmail(String email) async {
    await _storage.write(key: _keySavedEmail, value: email);
  }

  Future<String?> getSavedEmail() async {
    return await _storage.read(key: _keySavedEmail);
  }

  Future<void> deleteSavedEmail() async {
    await _storage.delete(key: _keySavedEmail);
  }

  Future<void> saveSavedPassword(String password) async {
    await _storage.write(key: _keySavedPassword, value: password);
  }

  Future<String?> getSavedPassword() async {
    return await _storage.read(key: _keySavedPassword);
  }

  Future<void> deleteSavedPassword() async {
    await _storage.delete(key: _keySavedPassword);
  }

  Future<void> clearSession() async {
    await deleteToken();
    await deleteUser();
  }
}