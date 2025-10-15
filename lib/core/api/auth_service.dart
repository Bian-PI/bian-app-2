import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/secure_storage.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2:8080/auth";

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await SecureStorage().saveToken(token);
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password, String phone, String cedula) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "cedula": cedula,
      }),
    );
    return response.statusCode == 201;
  }
}
