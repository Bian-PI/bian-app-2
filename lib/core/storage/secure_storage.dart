import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  // Keys
  static const String _keyToken = 'token';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserRole = 'user_role';
  static const String _keyUserId = 'user_id';

  /// Guarda el token JWT
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Obtiene el token JWT
  Future<String?> getToken() async {
    return _storage.read(key: _keyToken);
  }

  /// Guarda los datos del usuario
  Future<void> saveUserData({
    required String name,
    required String email,
    String? role,
    String? id,
  }) async {
    await _storage.write(key: _keyUserName, value: name);
    await _storage.write(key: _keyUserEmail, value: email);
    if (role != null) await _storage.write(key: _keyUserRole, value: role);
    if (id != null) await _storage.write(key: _keyUserId, value: id);
  }

  /// Obtiene el nombre del usuario
  Future<String?> getUserName() async {
    return _storage.read(key: _keyUserName);
  }

  /// Obtiene el email del usuario
  Future<String?> getUserEmail() async {
    return _storage.read(key: _keyUserEmail);
  }

  /// Obtiene el rol del usuario
  Future<String?> getUserRole() async {
    return _storage.read(key: _keyUserRole);
  }

  /// Obtiene el ID del usuario
  Future<String?> getUserId() async {
    return _storage.read(key: _keyUserId);
  }

  /// Obtiene todos los datos del usuario
  Future<Map<String, String?>> getAllUserData() async {
    return {
      'name': await getUserName(),
      'email': await getUserEmail(),
      'role': await getUserRole(),
      'id': await getUserId(),
    };
  }

  /// Verifica si hay una sesión activa
  Future<bool> hasActiveSession() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Limpia todos los datos almacenados
  Future<void> clear() async {
    await _storage.deleteAll();
  }
}