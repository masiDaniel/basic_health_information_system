import 'package:health_frontend/models/program_model.dart';

class Client {
  final int id;
  final String email;
  final int age;
  final String gender;
  final List<ProgramSkimmed> programs;

  Client({
    required this.id,
    required this.email,
    required this.age,
    required this.gender,
    required this.programs,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    var programsList =
        (json['programs'] != null)
            ? (json['programs'] as List)
                .map((programJson) => ProgramSkimmed.fromJson(programJson))
                .toList()
            : <ProgramSkimmed>[]; // if programs is null, just use an empty list

    return Client(
      id: json['id'],
      email: json['email'],
      age: json['age'],
      gender: json['gender'],
      programs: programsList,
    );
  }
}
