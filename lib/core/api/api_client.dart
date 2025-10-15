import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = "http://10.0.2.2:8080"; // tu API local o URL del backend

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) {
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: body != null ? body.toString() : '',
    );
  }
}
