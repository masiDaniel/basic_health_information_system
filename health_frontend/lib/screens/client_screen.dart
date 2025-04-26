import 'package:flutter/material.dart';
import 'package:health_frontend/models/client_profile_model.dart';
import 'package:health_frontend/screens/client_profile_screen.dart';
import 'package:health_frontend/screens/programs_screen.dart';
import 'package:health_frontend/services/client_services.dart';

class ClientDetailsScreen extends StatefulWidget {
  const ClientDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  List<Client> clients = [];
  List<Client> filteredClients = [];
  int? selectedClientId;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchClients();
    searchController.addListener(_onSearchChanged);
  }

  Future<void> fetchClients() async {
    try {
      final fetchedClients = await ClientService().fetchClients();
      setState(() {
        clients = fetchedClients;
        filteredClients = fetchedClients;
      });
    } catch (e) {
      print('Error fetching clients: $e');
    }
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredClients =
          clients.where((client) {
            final emailLower = client.email.toLowerCase();
            return emailLower.contains(query);
          }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void navigateToClientProfile(Client client) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientProfileScreen(client: client),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clients'),
        centerTitle: true,
        backgroundColor: Colors.blue,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Clients',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Clients List
            Expanded(
              child:
                  filteredClients.isEmpty
                      ? Center(child: Text('No clients available'))
                      : ListView.separated(
                        itemCount: filteredClients.length,
                        separatorBuilder:
                            (context, index) => Divider(height: 1),
                        itemBuilder: (context, index) {
                          final client = filteredClients[index];
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                client.email[0].toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
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
                              navigateToClientProfile(client);
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
