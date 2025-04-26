import 'package:flutter/material.dart';
import 'package:health_frontend/models/client_profile_model.dart';
import 'package:health_frontend/models/program_model.dart';
import 'package:health_frontend/services/program_services.dart';

class ClientProfileScreen extends StatefulWidget {
  final Client client;

  const ClientProfileScreen({Key? key, required this.client}) : super(key: key);

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  List<Program> allPrograms = [];
  List<int> selectedProgramIds = [];

  Future<void> _fetchPrograms() async {
    try {
      final programs = await ProgramService().getAllPrograms();
      setState(() {
        allPrograms = programs;
      });
    } catch (e) {
      print('Error fetching programs: $e');
    }
  }

  void _showProgramSelectionDialog() async {
    await _fetchPrograms();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // <-- StateSetter here
            return AlertDialog(
              title: Text('Select Programs'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allPrograms.length,
                  itemBuilder: (context, index) {
                    final program = allPrograms[index];
                    return CheckboxListTile(
                      title: Text(program.name),
                      subtitle: Text('Location: ${program.location}'),
                      value: selectedProgramIds.contains(program.id),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            selectedProgramIds.add(program.id);
                          } else {
                            selectedProgramIds.remove(program.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _assignProgramsToClient();
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _assignProgramsToClient() async {
    try {
      await ProgramService().addClientToPrograms(
        clientId: widget.client.id,
        programIds: selectedProgramIds,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Programs assigned successfully!')),
      );
    } catch (e) {
      print('Error assigning programs: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to assign programs')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = widget.client;
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              client.email,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Age: ${client.age}'),
            Text('Gender: ${client.gender}'),
            SizedBox(height: 24),
            Text(
              'Programs:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            ...client.programs
                .map(
                  (program) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${program.name}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text('Start Date: ${program.startDate}'),
                        Text('End Date: ${program.endDate}'),
                        Text('Goals: ${program.goals}'),
                        Text('Location: ${program.location}'),
                        Divider(),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showProgramSelectionDialog,
        label: Text('Add to Programs', style: TextStyle(color: Colors.white)),
        icon: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
