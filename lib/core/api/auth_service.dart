import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_client.dart';

class AuthService {
  Future<bool> register(String name, String email, String password, String phone, String document) async {
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
      return true;
    } else {
      print('⚠️ Error ${response.statusCode}: ${response.body}');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    final response = await ApiClient.post(
      '/auth/login',
      {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('⚠️ Error login ${response.statusCode}: ${response.body}');
      return false;
    }
  }
}
