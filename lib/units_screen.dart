import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webadmin_pinesville/menu.dart';
import 'package:webadmin_pinesville/pending_applications.dart';
import 'package:webadmin_pinesville/tenants_screen.dart';

class UnitsScreen extends StatelessWidget {
  const UnitsScreen({super.key});

  String formatTimestamp(dynamic value) {
    if (value is Timestamp) {
      final date = value.toDate();
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final searchController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Row(
        children: [
          SidebarMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Pages / Units Management',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
                  ),
                  Text(
                    'Units Management',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Invite Tenant Section
                  _buildInviteSection(context, emailController),

                  const SizedBox(height: 30),

                  // Search, Filter, and Actions
                  _buildSearchAndActions(context, searchController),

                  const SizedBox(height: 20),

                  // Table Header
                  _buildTableHeader(),

                  // Tenant List
                  Expanded(child: _buildTenantList(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInviteSection(BuildContext context, TextEditingController emailController) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Invite new tenants',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Share link or invite tenant via email address',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'https://pinesville/...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    suffixIcon: const Icon(Icons.copy, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email Address',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // TODO: Send link logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A3A3A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                ),
                child: const Text('Send Link'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndActions(BuildContext context, TextEditingController searchController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search for tenants and unit numbers',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.filter_list),
          label: const Text('Filter'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3A3A3A),
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PendingApplicationsScreen()),
            );
          },
          icon: const Icon(Icons.pending_actions),
          label: const Text('Pending applications'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3A3A3A),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: const [
        Expanded(child: Text("Unit", style: TextStyle(color: Colors.white70))),
        Expanded(child: Text("Name", style: TextStyle(color: Colors.white70))),
        Expanded(child: Text("Move-in Date", style: TextStyle(color: Colors.white70))),
        SizedBox(width: 60, child: Text("Actions", style: TextStyle(color: Colors.white70))),
      ],
    );
  }

  Widget _buildTenantList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final tenants = snapshot.data!.docs;

        return ListView.builder(
          itemCount: tenants.length,
          itemBuilder: (context, index) {
            final tenantDoc = tenants[index];
            final data = tenantDoc.data() as Map<String, dynamic>;
            final docId = tenantDoc.id;

            final unit = data['UnitNo'] ?? 'N/A';
            final name = "${data['FirstName'] ?? ''} ${data['LastName'] ?? ''}".trim();
            final email = data['Email'] ?? 'noemail@domain.com';
            final moveInDateValue = data['MoveInDate'];
            String moveInDate;
            if (moveInDateValue is Timestamp) {
              moveInDate = moveInDateValue.toDate().toLocal().toString().split(' ')[0];
            } else if (moveInDateValue is String) {
              moveInDate = moveInDateValue;
            } else {
              moveInDate = 'N/A';
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TenantsScreen(tenantId: docId)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(child: Text(unit, style: const TextStyle(color: Colors.white))),
                    Expanded(
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage('assets/avatars/avatar.png'),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: const TextStyle(color: Colors.white)),
                              Text(email, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Text(moveInDate, style: const TextStyle(color: Colors.white))),
                    SizedBox(
                      width: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.grey),
                            onPressed: () {
                              // TODO: Handle edit
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.grey),
                            onPressed: () async {
                              try {
                                await FirebaseFirestore.instance.collection('tenants').doc(docId).delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Tenant deleted')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to delete tenant: $e')),
                                );
                              }
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}