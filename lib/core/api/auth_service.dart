import 'dart:convert';
import 'api_client.dart';

class AuthService {
  /// Verifica si un email ya existe en el sistema
  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await ApiClient.post(
        '/auth/check-email',
        {"email": email},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['exists'] ?? false;
      }
      return false;
    } catch (e) {
      print('⚠️ Error verificando email: $e');
      return false;
    }
  }

  /// Verifica si un documento ya existe en el sistema
  Future<bool> checkDocumentExists(String document) async {
    try {
      final response = await ApiClient.post(
        '/auth/check-document',
        {"document": document},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['exists'] ?? false;
      }
      return false;
    } catch (e) {
      print('⚠️ Error verificando documento: $e');
      return false;
    }
  }

  /// Registra un nuevo usuario
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String phone,
    String document,
  ) async {
    try {
      final response = await ApiClient.post(
        '/auth/register',
        {
          "name": name,
          "email": email,
          "password": password,
          "phone": phone,
          "document": document,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Registro exitoso',
        };
      } else if (response.statusCode == 409) {
        // Conflicto - email o documento ya existe
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['error'] ?? 'El usuario ya existe',
        };
      } else {
        print('⚠️ Error ${response.statusCode}: ${response.body}');
        return {
          'success': false,
          'message': 'Error al registrar. Intenta de nuevo',
        };
      }
    } catch (e) {
      print('⚠️ Error en registro: $e');
      return {
        'success': false,
        'message': 'Error de conexión',
      };
    }
  }

  /// Inicia sesión
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await ApiClient.post(
        '/auth/login',
        {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Extraer datos del usuario si están disponibles
        Map<String, dynamic>? userData;
        if (data['user'] != null) {
          userData = {
            'name': data['user']['name'],
            'email': data['user']['email'],
            'role': data['user']['role'] ?? 'user',
          };
        }
        
        return {
          'success': true,
          'token': data['token'],
          'user': userData,
        };
      } else if (response.statusCode == 401) {
        print('⚠️ Error login ${response.statusCode}: ${response.body}');
        return {
          'success': false,
          'message': 'Credenciales incorrectas',
        };
      } else {
        print('⚠️ Error login ${response.statusCode}: ${response.body}');
        return {
          'success': false,
          'message': 'Error al iniciar sesión',
        };
      }
    } catch (e) {
      print('⚠️ Error login: $e');
      return {
        'success': false,
        'message': 'Error de conexión',
      };
    }
  }

  // Mantener compatibilidad con código antiguo
  // Estos métodos llaman a las versiones nuevas
  @Deprecated('Usa la nueva versión que retorna Map')
  Future<bool> registerSimple(
    String name,
    String email,
    String password,
    String phone,
    String document,
  ) async {
    final result = await register(name, email, password, phone, document);
    return result['success'] == true;
  }

  @Deprecated('Usa la nueva versión que retorna Map')
  Future<bool> loginSimple(String email, String password) async {
    final result = await login(email, password);
    return result['success'] == true;
  }
}