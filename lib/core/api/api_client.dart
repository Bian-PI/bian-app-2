import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = "http://10.0.2.2:8081"; // backend local para emulador Android

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('📡 POST: $url');
    print('➡️ Body: $body');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      print('✅ Status: ${response.statusCode}');
      print('📥 Response: ${response.body}');
      return response;
    } catch (e) {
      print('❌ Error en la petición: $e');
      rethrow;
    }
  }
}
