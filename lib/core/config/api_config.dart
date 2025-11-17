class ApiConfig {
  // Base URL
  static const String baseUrl = "http://10.0.2.2:8081";
  static const String mailServiceUrl = "http://10.0.2.2:8082";
  
  // Auth Endpoints
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String refresh = "/auth/refresh";
  static const String verify = "/auth/verify";
  
  // User Endpoints (requieren JWT)
  static const String users = "/users";
  static String userById(int id) => "/users/$id";
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };
  
  static Map<String, String> headersWithToken(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}