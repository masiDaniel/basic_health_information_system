import 'package:flutter/material.dart';
import 'package:health_frontend/models/client_profile_model.dart';
import 'package:health_frontend/models/program_model.dart';
import 'package:health_frontend/services/client_services.dart';
import 'package:health_frontend/services/program_services.dart';

class ProgramDetailsScreen extends StatefulWidget {
  final Program program;

  const ProgramDetailsScreen({Key? key, required this.program})
    : super(key: key);

  @override
  State<ProgramDetailsScreen> createState() => _ProgramDetailsScreenState();
}

class _ProgramDetailsScreenState extends State<ProgramDetailsScreen> {
  List<Client> clients = [];
  int? selectedClientId;

  @override
  void initState() {
    super.initState();
    fetchClients();
  }

  Future<void> fetchClients() async {
    try {
      print('we are here');
      final fetchedClients = await ClientService().fetchClients();
      // final filteredClients =
      //     fetchedClients.where((client) {
      //       return !client.programs.any((p) => p.id == widget.program.id);
      //     }).toList();
      print('we are here 1');

      setState(() {
        clients = fetchedClients;
      });

      print('we are here 2');
    } catch (e) {
      print('Error fetching clients: $e');
    }
  }

  Future<void> addClientToProgram() async {
    if (selectedClientId == null) return;

    try {
      await ProgramService().addClientToProgram(
        clientId: selectedClientId!,
        programId: widget.program.id,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Client added to program successfully!')),
      );
      Navigator.pop(context); // Go back after adding
    } catch (e) {
      print('Error adding client: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.program.name),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // Custom color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Program Information
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location: ${widget.program.location}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Start: ${widget.program.startDate.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Text(
                      'End: ${widget.program.endDate.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Clients Title
            Text(
              'Available Clients',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Clients List
            Expanded(
              child:
                  clients.isEmpty
                      ? Center(child: Text('No clients available'))
                      : ListView.separated(
                        itemCount: clients.length,
                        separatorBuilder:
                            (context, index) => Divider(height: 1),
                        itemBuilder: (context, index) {
                          final client = clients[index];
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            leading: CircleAvatar(
                              child: Text(
                                client.email[0].toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.deepPurple,
                            ),
                            title: Text(client.email),
                            subtitle: Text(
                              'Age: ${client.age}, Gender: ${client.gender}',
                            ),
                            trailing:
                                selectedClientId == client.id
                                    ? Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                    : null,
                            selected: selectedClientId == client.id,
                            onTap: () {
                              setState(() {
                                selectedClientId = client.id;
                              });
                            },
                          );
                        },
                      ),
            ),

            if (selectedClientId != null) ...[
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: addClientToProgram,
                  icon: Icon(Icons.add),
                  label: Text('Add Client'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
