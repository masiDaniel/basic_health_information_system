import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:health_frontend/models/program_model.dart';
import 'package:health_frontend/screens/create_program_screen.dart';
import 'package:health_frontend/screens/program_details_screen.dart';
import 'package:health_frontend/services/program_services.dart';

class ProgramsScreen extends StatefulWidget {
  @override
  _ProgramsScreenState createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  List<Program> _allPrograms = [];
  List<Program> _filteredPrograms = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPrograms();
  }

  Future<void> _fetchPrograms() async {
    try {
      final programs = await ProgramService().getAllPrograms();
      setState(() {
        _allPrograms = programs;
        _filteredPrograms = programs;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching programs: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterPrograms(String query) {
    final filtered =
        _allPrograms.where((program) {
          return program.name.toLowerCase().contains(query.toLowerCase()) ||
              program.location.toLowerCase().contains(query.toLowerCase());
        }).toList();

    setState(() {
      _searchQuery = query;
      _filteredPrograms = filtered;
    });
  }

  void _goToCreateProgram() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateProgramScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Programs')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search programs...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: _filterPrograms,
                    ),
                  ),
                  Expanded(
                    child:
                        _filteredPrograms.isEmpty
                            ? Center(child: Text('No programs found.'))
                            : ListView.builder(
                              itemCount: _filteredPrograms.length,
                              itemBuilder: (context, index) {
                                final program = _filteredPrograms[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    title: Text(program.name),
                                    subtitle: Text(
                                      '${program.location} | ${program.startDate.toLocal().toString().split(' ')[0]} → ${program.endDate.toLocal().toString().split(' ')[0]}',
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ProgramDetailsScreen(
                                                program: program,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: Icon(Icons.create),
            label: 'Create Program',
            onTap: _goToCreateProgram,
          ),
          SpeedDialChild(
            child: Icon(Icons.person_add),
            label: 'Create Client',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
