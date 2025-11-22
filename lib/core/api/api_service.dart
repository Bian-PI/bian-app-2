import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../storage/secure_storage.dart';

class ApiService {
  final _storage = SecureStorage();

  // Helper para hacer peticiones GET
  Future<http.Response> get(String endpoint, {bool requiresAuth = true}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    
    Map<String, String> headers = ApiConfig.headers;
    
    if (requiresAuth) {
      final token = await _storage.getToken();
      if (token != null) {
        headers = ApiConfig.headersWithToken(token);
      }
    }
    
    try {
      final response = await http.get(url, headers: headers)
          .timeout(ApiConfig.receiveTimeout);
      return response;
    } catch (e) {
      print('❌ Error en GET $endpoint: $e');
      throw Exception('Error en GET $endpoint: $e');
    }
  }

  // Helper para hacer peticiones POST
  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    
    Map<String, String> headers = ApiConfig.headers;
    
    if (requiresAuth) {
      final token = await _storage.getToken();
      if (token != null) {
        headers = ApiConfig.headersWithToken(token);
      }
    }
    
    try {
      print('📤 POST $endpoint');
      print('📦 Body: $body');
      
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(ApiConfig.receiveTimeout);
      
      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');
      
      return response;
    } catch (e) {
      print('❌ Error en POST $endpoint: $e');
      throw Exception('Error en POST $endpoint: $e');
    }
  }

  // Helper para hacer peticiones PUT
  Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    
    Map<String, String> headers = ApiConfig.headers;
    
    if (requiresAuth) {
      final token = await _storage.getToken();
      if (token != null) {
        headers = ApiConfig.headersWithToken(token);
      }
    }
    
    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(ApiConfig.receiveTimeout);
      
      return response;
    } catch (e) {
      throw Exception('Error en PUT $endpoint: $e');
    }
  }

  // Helper para hacer peticiones DELETE
  Future<http.Response> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    
    Map<String, String> headers = ApiConfig.headers;
    
    if (requiresAuth) {
      final token = await _storage.getToken();
      if (token != null) {
        headers = ApiConfig.headersWithToken(token);
      }
    }
    
    try {
      final response = await http.delete(url, headers: headers)
          .timeout(ApiConfig.receiveTimeout);
      return response;
    } catch (e) {
      throw Exception('Error en DELETE $endpoint: $e');
    }
  }

  // ========== AUTH ENDPOINTS ==========
  
  /// POST /auth/login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await post(
        ApiConfig.login,
        {'email': email, 'password': password},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
        };
      } else if (response.statusCode == 403) {
        // Usuario no verificado
        try {
          final data = jsonDecode(response.body);
          if (data['code'] == 'USER_NOT_VERIFIED') {
            return {
              'success': false,
              'message': 'user_not_verified',
              'email': data['email'],
              'userId': data['userId'],
            };
          }
        } catch (_) {}
        return {
          'success': false,
          'message': 'user_not_verified',
          'email': email,
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'invalid_credentials',
        };
      } else {
        return {
          'success': false,
          'message': 'server_error',
        };
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        return {'success': false, 'message': 'timeout_error'};
      }
      return {'success': false, 'message': 'connection_error'};
    }
  }

  /// POST /auth/register
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await post(ApiConfig.register, userData);
      
      print('📥 Status Code: ${response.statusCode}');
      print('📥 Body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'user': data['user'],
          'token': data['token'],
        };
      } else if (response.statusCode == 403) {
        try {
          final data = jsonDecode(response.body);
          if (data['code'] == 'USER_NOT_VERIFIED') {
            return {
              'success': true,
              'user_not_verified': true,
              'email': userData['email'],
              'userId': data['userId'],
            };
          }
        } catch (_) {}
        return {
          'success': true,
          'user_not_verified': true,
          'email': userData['email'],
        };
      } else if (response.statusCode == 409) {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['error'] ?? 'user_exists',
        };
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['error'] ?? data['message'] ?? 'validation_error',
        };
      } else {
        return {
          'success': false,
          'message': 'server_error',
        };
      }
    } catch (e) {
      print('💥 Exception en register: $e');
      if (e.toString().contains('TimeoutException')) {
        return {'success': false, 'message': 'timeout_error'};
      }
      return {'success': false, 'message': 'connection_error'};
    }
  }

  /// POST /auth/refresh
  Future<Map<String, dynamic>> refreshToken(String token) async {
    try {
      final response = await post(
        ApiConfig.refresh,
        {'token': token},
        requiresAuth: true,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'token': data['token'],
        };
      } else {
        return {'success': false, 'message': 'server_error'};
      }
    } catch (e) {
      return {'success': false, 'message': 'connection_error'};
    }
  }

  /// Reenviar email de verificación
  Future<Map<String, dynamic>> resendVerificationEmail(int userId, String email) async {
    try {
      final url = Uri.parse('${ApiConfig.mailServiceUrl}/api/email/send/$userId?email=$email');
      
      print('📤 Reenviando email de verificación a: $url');
      
      final response = await http.post(url).timeout(ApiConfig.receiveTimeout);
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'verification_sent',
        };
      } else {
        return {
          'success': false,
          'message': 'server_error',
        };
      }
    } catch (e) {
      print('❌ Error reenviando email: $e');
      return {'success': false, 'message': 'connection_error'};
    }
  }

  // ========== USER ENDPOINTS ==========
  
  /// GET /users
  Future<Map<String, dynamic>> getAllUsers() async {
    try {
      final response = await get(ApiConfig.users);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return {
          'success': true,
          'users': data,
        };
      } else {
        return {'success': false, 'message': 'server_error'};
      }
    } catch (e) {
      return {'success': false, 'message': 'connection_error'};
    }
  }

  /// GET /users/{id}
  Future<Map<String, dynamic>> getUserById(int id) async {
    try {
      final response = await get(ApiConfig.userById(id));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'user': data,
        };
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'user_not_found'};
      } else {
        return {'success': false, 'message': 'server_error'};
      }
    } catch (e) {
      return {'success': false, 'message': 'connection_error'};
    }
  }

  /// POST /users
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await post(ApiConfig.users, userData, requiresAuth: true);
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
        };
      } else if (response.statusCode == 409) {
        return {'success': false, 'message': 'user_exists'};
      } else {
        return {'success': false, 'message': 'server_error'};
      }
    } catch (e) {
      return {'success': false, 'message': 'connection_error'};
    }
  }

  /// PUT /users/{id}
  Future<Map<String, dynamic>> updateUser(int id, Map<String, dynamic> userData) async {
    try {
      final response = await put(ApiConfig.userById(id), userData);
      
      print('📥 Update status: ${response.statusCode}');
      print('📥 Update body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
        };
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'user_not_found'};
      } else if (response.statusCode == 409) {
        return {'success': false, 'message': 'user_exists'};
      } else {
        print('❌ Error response: ${response.body}');
        return {'success': false, 'message': 'server_error'};
      }
    } catch (e) {
      print('💥 Exception: $e');
      return {'success': false, 'message': 'connection_error'};
    }
  }

  /// DELETE /users/{id}
  Future<Map<String, dynamic>> deleteUser(int id) async {
    try {
      final response = await delete(ApiConfig.userById(id));
      
      if (response.statusCode == 204 || response.statusCode == 200) {
        return {
          'success': true,
          'message': 'user_deleted',
        };
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'user_not_found'};
      } else {
        return {'success': false, 'message': 'server_error'};
      }
    } catch (e) {
      return {'success': false, 'message': 'connection_error'};
    }
  }

  // ========== SYNC ENDPOINTS ==========

  /// POST /evaluations/sync - Sincronizar reporte offline
  Future<Map<String, dynamic>> syncOfflineReport(Map<String, dynamic> reportData) async {
    try {
      print('📤 Sincronizando reporte offline...');
      print('📦 Data: $reportData');
      
      final response = await post(
        '/evaluations/sync',
        reportData,
        requiresAuth: false,
      );
      
      print('📥 Sync response status: ${response.statusCode}');
      print('📥 Sync response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'report_synced',
          'data': data,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'user_not_found',
        };
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['error'] ?? 'validation_error',
        };
      } else {
        return {
          'success': false,
          'message': 'server_error',
        };
      }
    } catch (e) {
      print('❌ Error sincronizando reporte: $e');
      if (e.toString().contains('TimeoutException')) {
        return {'success': false, 'message': 'timeout_error'};
      }
      return {'success': false, 'message': 'connection_error'};
    }
  }

  /// GET /users/document/{document} - Buscar usuario por documento
  Future<Map<String, dynamic>> getUserByDocument(String document) async {
    try {
      final response = await get('/users/document/$document', requiresAuth: false);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'user': data,
        };
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'user_not_found'};
      } else {
        return {'success': false, 'message': 'server_error'};
      }
    } catch (e) {
      return {'success': false, 'message': 'connection_error'};
    }
  }
}