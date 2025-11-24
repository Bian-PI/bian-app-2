import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../storage/secure_storage.dart';

class ApiService {
  final _storage = SecureStorage();

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

  Future<Map<String, dynamic>> resendVerificationEmail(int userId, String email) async {
    try {
      final url = Uri.parse('${ApiConfig.mailServiceUrl}/api/email/send/$userId?email=$email');

      print('📤 Reenviando email de verificación...');
      print('📍 URL: $url');
      print('📍 Mail Service URL: ${ApiConfig.mailServiceUrl}');
      print('📍 User ID: $userId');
      print('📍 Email: $email');

      final response = await http.post(
        url,
        headers: ApiConfig.headers,
      ).timeout(
        ApiConfig.receiveTimeout,
        onTimeout: () {
          print('⏱️ Timeout al enviar email de verificación');
          throw Exception('Timeout');
        },
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'verification_sent',
        };
      } else if (response.statusCode == 404) {
        print('❌ Usuario no encontrado en servicio de correos');
        return {
          'success': false,
          'message': 'user_not_found',
        };
      } else {
        print('❌ Error del servidor de correos: ${response.statusCode}');
        return {
          'success': false,
          'message': 'server_error',
        };
      }
    } catch (e) {
      print('❌ Error reenviando email: $e');
      print('❌ Tipo de error: ${e.runtimeType}');
      if (e.toString().contains('TimeoutException') || e.toString().contains('Timeout')) {
        return {'success': false, 'message': 'timeout_error'};
      }
      if (e.toString().contains('SocketException')) {
        return {'success': false, 'message': 'connection_error'};
      }
      return {'success': false, 'message': 'connection_error'};
    }
  }

  
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

  Future<Map<String, dynamic>> getUserEvaluations({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      print('📥 Obteniendo reportes (limit: $limit, offset: $offset)...');

      final response = await get(
        '/evaluations/user?limit=$limit&offset=$offset',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'evaluations': data['evaluations'] ?? [],
          'total': data['total'] ?? 0,
          'hasMore': data['hasMore'] ?? false,
        };
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': 'unauthorized'};
      } else {
        return {'success': false, 'message': 'server_error'};
      }
    } catch (e) {
      print('❌ Error obteniendo reportes: $e');
      return {'success': false, 'message': 'connection_error'};
    }
  }

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

  // ========== MÉTODOS PARA BACKEND JAVA (EVALUACIONES) ==========

  /// Crea un nuevo reporte de evaluación en el backend Java
  ///
  /// [evaluationData] debe contener toda la información del reporte:
  /// - connection_status: String
  /// - user_id: String
  /// - evaluation_date: String (formato: YYYY-MM-DD)
  /// - language: String (ej: "es", "en")
  /// - species: String
  /// - farm_name: String
  /// - farm_location: String
  /// - evaluator_name: String
  /// - status: String
  /// - overall_score: String
  /// - compliance_level: String
  /// - categories: Map<String, dynamic>
  /// - critical_points: List<Map<String, String>>
  /// - strong_points: List<Map<String, String>>
  /// - recommendations: List<String>
  Future<Map<String, dynamic>> createEvaluationReport(Map<String, dynamic> evaluationData) async {
    try {
      final url = Uri.parse('${ApiConfig.evaluationsBaseUrl}${ApiConfig.createEvaluation}');

      print('📤 Creando reporte de evaluación en: $url');
      print('📦 Data: $evaluationData');

      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: jsonEncode(evaluationData),
      ).timeout(ApiConfig.receiveTimeout);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Registro creado correctamente.',
        };
      } else if (response.statusCode == 400) {
        return {
          'success': false,
          'message': 'validation_error',
        };
      } else {
        return {
          'success': false,
          'message': 'server_error',
        };
      }
    } catch (e) {
      print('❌ Error creando reporte: $e');
      if (e.toString().contains('TimeoutException')) {
        return {'success': false, 'message': 'timeout_error'};
      }
      return {'success': false, 'message': 'connection_error'};
    }
  }

  /// Obtiene un reporte específico por su ID de evaluación
  ///
  /// [evaluationId]: ID único del reporte de evaluación
  Future<Map<String, dynamic>> getEvaluationById(String evaluationId) async {
    try {
      final url = Uri.parse('${ApiConfig.evaluationsBaseUrl}${ApiConfig.getEvaluationById(evaluationId)}');

      print('📥 Obteniendo reporte: $url');

      final response = await http.get(
        url,
        headers: ApiConfig.headers,
      ).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'evaluation': data,
        };
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'evaluation_not_found'};
      } else {
        return {'success': false, 'message': 'server_error'};
      }
    } catch (e) {
      print('❌ Error obteniendo reporte: $e');
      return {'success': false, 'message': 'connection_error'};
    }
  }

  /// Obtiene todos los reportes de un usuario específico
  ///
  /// [userId]: ID del usuario
  Future<Map<String, dynamic>> getAllUserEvaluationReports(String userId) async {
    try {
      final url = Uri.parse('${ApiConfig.evaluationsBaseUrl}${ApiConfig.getAllUserEvaluations(userId)}');

      print('📥 Obteniendo todos los reportes del usuario $userId: $url');

      final response = await http.get(
        url,
        headers: ApiConfig.headers,
      ).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return {
          'success': true,
          'evaluations': data,
          'total': data.length,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'user_not_found',
        };
      } else {
        return {
          'success': false,
          'message': 'server_error',
        };
      }
    } catch (e) {
      print('❌ Error obteniendo reportes del usuario: $e');
      return {'success': false, 'message': 'connection_error'};
    }
  }

  /// Obtiene reportes para usuarios administradores
  ///
  /// [adminId]: ID del usuario administrador
  Future<Map<String, dynamic>> getAdminEvaluationReports(int adminId) async {
    try {
      final url = Uri.parse('${ApiConfig.evaluationsBaseUrl}${ApiConfig.getAdminEvaluations(adminId)}');

      print('📥 Obteniendo reportes para admin $adminId: $url');

      final response = await http.get(
        url,
        headers: ApiConfig.headers,
      ).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return {
          'success': true,
          'evaluations': data,
          'total': data.length,
        };
      } else {
        return {
          'success': false,
          'message': 'server_error',
        };
      }
    } catch (e) {
      print('❌ Error obteniendo reportes admin: $e');
      return {'success': false, 'message': 'connection_error'};
    }
  }
}