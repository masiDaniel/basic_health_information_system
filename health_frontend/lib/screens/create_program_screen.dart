import 'package:flutter/material.dart';
import 'package:health_frontend/models/program_model.dart';
import 'package:health_frontend/services/program_services.dart';

class CreateProgramScreen extends StatefulWidget {
  @override
  _CreateProgramScreenState createState() => _CreateProgramScreenState();
}

class _CreateProgramScreenState extends State<CreateProgramScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _goalsController = TextEditingController();
  final _guidelinesController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _endDate != null) {
      try {
        final newProgram = CreateProgram(
          name: _nameController.text,
          doctor: 1,
          description: _descriptionController.text,
          startDate: _startDate!,
          endDate: _endDate!,
          location: _locationController.text,
          goals: _goalsController.text,
          treatmentGuidelines: _guidelinesController.text,
        );
        await ProgramService().createProgram(newProgram);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Program created successfully')));
        Navigator.pop(context);
      } catch (e) {
        print('Failed to create program: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create program')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Program')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Program Name'),
                  validator: (value) => value!.isEmpty ? 'Enter a name' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator:
                      (value) => value!.isEmpty ? 'Enter a description' : null,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _startDate == null
                            ? 'Start Date'
                            : 'Start: ${_startDate!.toLocal()}'.split(' ')[0],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context, true),
                      child: Text('Pick Start Date'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _endDate == null
                            ? 'End Date'
                            : 'End: ${_endDate!.toLocal()}'.split(' ')[0],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context, false),
                      child: Text('Pick End Date'),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                  validator:
                      (value) => value!.isEmpty ? 'Enter a location' : null,
                ),
                TextFormField(
                  controller: _goalsController,
                  decoration: InputDecoration(labelText: 'Goals'),
                  validator:
                      (value) => value!.isEmpty ? 'Enter program goals' : null,
                ),
                TextFormField(
                  controller: _guidelinesController,
                  decoration: InputDecoration(
                    labelText: 'Treatment Guidelines',
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Enter treatment guidelines' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Create Program'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
