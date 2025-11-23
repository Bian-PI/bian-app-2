class ApiConfig {
  static const String baseUrl = "http:
  static const String mailServiceUrl = "http:
  
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