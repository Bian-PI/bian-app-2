import 'package:flutter_dotenv/flutter_dotenv.dart';
class ApiConfig {
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8081';
  static final String mailServiceUrl = dotenv.env['MAIL_SERVICE_URL'] ?? 'http://10.0.2.2:8080';
  static final String evaluationsBaseUrl = dotenv.env['EVALUATIONS_BASE_URL'] ?? 'http://10.0.2.2:8089';

  // Auth endpoints
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String refresh = "/auth/refresh";
  static const String verify = "/auth/verify";

  // User endpoints
  static const String users = "/users";
  static String userById(int id) => "/users/$id";

  // Evaluation endpoints (Backend Java)
  static const String createEvaluation = "/animals/evaluation";
  static String getEvaluationById(String evaluationId) => "/animals/evaluation/$evaluationId";
  static String getAllUserEvaluations(String userId) => "/animals/evaluation/all/$userId";
  static String getAdminEvaluations(int adminId) => "/animals/evaluation/users/$adminId";
  static const String getAllEvaluations = "/animals/evaluation/all"; // Para admins: TODOS los reportes

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };

  static Map<String, String> headersWithToken(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
