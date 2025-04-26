class Client {
  final int id;
  final String email;
  final int age;
  final String gender;

  Client({
    required this.id,
    required this.email,
    required this.age,
    required this.gender,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      email: json['email'],
      age: json['age'],
      gender: json['gender'],
    );
  }
}
