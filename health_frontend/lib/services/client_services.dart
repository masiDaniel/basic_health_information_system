import 'package:health_frontend/models/client_profile_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ClientService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<Client>> fetchClients() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/programs/clients/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      print('here 1');
      final List data = json.decode(response.body);
      print('Data fetched: $data');
      print('here 2');
      return data.map((clientJson) => Client.fromJson(clientJson)).toList();
    } else {
      throw Exception('Failed to load clients');
    }
  }
}
