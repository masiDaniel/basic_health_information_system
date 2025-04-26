import 'package:flutter/material.dart';
import 'package:health_frontend/screens/programs_screen.dart';
import 'package:health_frontend/services/client_services.dart'; // Assume you have this

class CreateClientScreen extends StatefulWidget {
  @override
  _CreateClientScreenState createState() => _CreateClientScreenState();
}

class _CreateClientScreenState extends State<CreateClientScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final newClient = {
          "username": _usernameController.text,
          "email": _emailController.text,
          "password": 1234,
          "role": "client",
          "gender": _genderController.text,
          "age": int.parse(_ageController.text),
          "phone_number": _phoneController.text,
        };

        await ClientService().createClient(
          newClient,
        ); // You implement this service

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Client created successfully')));
        Navigator.pop(context);
      } catch (e) {
        print('Failed to create client: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create client')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Client'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ProgramsScreen()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                  validator:
                      (value) => value!.isEmpty ? 'Enter a username' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator:
                      (value) => value!.isEmpty ? 'Enter an email' : null,
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter age' : null,
                ),
                TextFormField(
                  controller: _genderController,
                  decoration: InputDecoration(labelText: 'Gender'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter gender' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator:
                      (value) => value!.isEmpty ? 'Enter phone number' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Create Client'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
