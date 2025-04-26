import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<Map<String, dynamic>> signIn(String username, String password) async {
    final url = Uri.parse('http://127.0.0.1:8000/accounts/login/');

    try {
      final response = await http.post(
        url,
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];

        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        return data; // <-- return the full response
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred during login: $e');
    }
  }
}
