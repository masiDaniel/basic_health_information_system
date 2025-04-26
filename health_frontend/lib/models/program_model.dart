class Program {
  final int id;
  final List<int> clients;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final String goals;
  final String treatmentGuidelines;
  final String location;
  final int doctor;

  Program({
    required this.id,
    required this.clients,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.goals,
    required this.treatmentGuidelines,
    required this.location,
    required this.doctor,
  });

  // Factory constructor to create a Program from JSON
  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'],
      clients: List<int>.from(json['clients']),
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      isActive: json['is_active'],
      goals: json['goals'],
      treatmentGuidelines: json['treatment_guidelines'],
      location: json['location'],
      doctor: json['doctor'],
    );
  }

  // Convert Program instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'clients': clients,
      'name': name,
      'description': description,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'is_active': isActive,
      'goals': goals,
      'treatment_guidelines': treatmentGuidelines,
      'location': location,
      'doctor': doctor,
    };
  }
}

class ProgramSkimmed {
  final int id;

  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final String goals;
  final String treatmentGuidelines;
  final String location;
  final int doctor;

  ProgramSkimmed({
    required this.id,

    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.goals,
    required this.treatmentGuidelines,
    required this.location,
    required this.doctor,
  });

  // Factory constructor to create a Program from JSON
  factory ProgramSkimmed.fromJson(Map<String, dynamic> json) {
    return ProgramSkimmed(
      id: json['id'],

      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      isActive: json['is_active'],
      goals: json['goals'],
      treatmentGuidelines: json['treatment_guidelines'],
      location: json['location'],
      doctor: json['doctor'],
    );
  }

  // Convert Program instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'is_active': isActive,
      'goals': goals,
      'treatment_guidelines': treatmentGuidelines,
      'location': location,
      'doctor': doctor,
    };
  }
}

class CreateProgram {
  final String name;
  final int doctor;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String goals;
  final String treatmentGuidelines;

  CreateProgram({
    required this.name,
    required this.doctor,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.goals,
    required this.treatmentGuidelines,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'doctor': doctor,
      'description': description,
      'start_date': startDate.toIso8601String().split('T').first,
      'end_date': endDate.toIso8601String().split('T').first,
      'location': location,
      'goals': goals,
      'treatment_guidelines': treatmentGuidelines,
    };
  }
}
