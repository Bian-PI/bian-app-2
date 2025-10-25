import '../../../core/api/auth_service.dart';
import '../../../core/storage/secure_storage.dart';

class AuthPresenter {
  final _service = AuthService();
  final _storage = SecureStorage();

  /// Verifica si un email ya existe
  Future<bool> checkEmailExists(String email) async {
    return _service.checkEmailExists(email);
  }

  /// Verifica si un documento ya existe
  Future<bool> checkDocumentExists(String document) async {
    return _service.checkDocumentExists(document);
  }

  /// Inicia sesión y guarda el token
  Future<bool> login(String email, String password) async {
    final result = await _service.login(email, password);
    
    if (result['success'] == true) {
      // Guardar token
      await _storage.saveToken(result['token']);
      
      // Guardar datos del usuario si están disponibles
      if (result['user'] != null) {
        final user = result['user'] as Map<String, dynamic>;
        await _storage.saveUserData(
          name: user['name'] ?? 'Usuario',
          email: user['email'] ?? email,
          role: user['role'] ?? 'user',
        );
      } else {
        // Si el backend no retorna datos del usuario, guardar solo el email
        await _storage.saveUserData(
          name: 'Usuario',
          email: email,
          role: 'user',
        );
      }
      
      return true;
    }
    
    return false;
  }

  /// Registra un nuevo usuario
  Future<bool> register(
    String name,
    String email,
    String password,
    String phone,
    String document,
  ) async {
    final result = await _service.register(name, email, password, phone, document);
    
    if (result['success'] == true) {
      // Si el registro es exitoso, también guarda el token si viene en la respuesta
      if (result['data'] != null && result['data']['token'] != null) {
        await _storage.saveToken(result['data']['token']);
        
        // Guardar datos del usuario
        await _storage.saveUserData(
          name: name,
          email: email,
          role: 'user',
        );
      }
      return true;
    }
    
    return false;
  }

  /// Cierra sesión
  Future<void> logout() async {
    await _storage.clear();
  }
}