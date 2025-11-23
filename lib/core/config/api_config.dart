import 'package:flutter_dotenv/flutter_dotenv.dart';
class ApiConfig {
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api/v1';
  static final String mailServiceUrl = dotenv.env['MAIL_SERVICE_URL'] ?? 'http://localhost:3001';

  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String refresh = "/auth/refresh";
  static const String verify = "/auth/verify";

  static const String users = "/users";
  static String userById(int id) => "/users/$id";

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
