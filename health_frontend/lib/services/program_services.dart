import 'dart:convert';
import 'package:health_frontend/models/program_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProgramService {
  final String baseUrl = 'http://127.0.0.1:8000/programs/programs/';

  // Get token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> createProgram(CreateProgram program) async {
    final token = await _getToken();
    final String baseUrl = 'http://127.0.0.1:8000/programs/create-program/';

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(program.toJson()),
    );

    if (response.statusCode == 201) {
    } else {
      // Failure - Something went wrong
      throw Exception('Failed to create program: ${response.body}');
    }
  }

  Future<List<Program>> getAllPrograms() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Program.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load programs');
    }
  }

  Future<Program> getProgramByName(String name) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$name/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      return Program.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get program $name');
    }
  }

  Future<void> addClientToPrograms({
    required int clientId,
    required List<int> programIds,
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/programs/programs/add-client/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      body: json.encode({
        'client_id': clientId,
        'program_ids': programIds, // send as a list, even if it's one ID
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add client to programs');
    }
  }
}
