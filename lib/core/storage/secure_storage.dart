import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/user_model.dart';

class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;
  SecureStorage._internal();

  final _storage = const FlutterSecureStorage();

  // Keys
  static const String _keyToken = 'jwt_token';
  static const String _keyUser = 'user_data';
  static const String _keyUserId = 'user_id';
  static const String _keyIsVerified = 'is_verified';

  // ========== TOKEN ==========
  
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  // ========== USER DATA ==========
  
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

  // ========== SESSION ==========
  
  Future<bool> hasActiveSession() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // ========== COMPLETE SESSION DATA ==========
  
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
}