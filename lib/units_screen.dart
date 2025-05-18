import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'menu.dart';
import 'pending_applications.dart';

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
    final TextEditingController emailController = TextEditingController();
    final TextEditingController searchController = TextEditingController();

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
                  Text(
                    'Pages / Tenant Management',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 0),
                  Text(
                    'Unit Management',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Invite tenants section
                  Container(
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
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[400],
                          ),
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
                                  suffixIcon: Icon(Icons.copy, color: Colors.grey),
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
                  ),
                  const SizedBox(height: 30),

                  // Search and filter
                  Row(
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
                            MaterialPageRoute(
                              builder: (context) => const PendingApplicationsScreen(),
                            ),
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
                  ),
                  const SizedBox(height: 20),

                  // Tenant list header
                  Row(
                    children: const [
                      Expanded(child: Text("Unit", style: TextStyle(color: Colors.white70))),
                      Expanded(child: Text("Name", style: TextStyle(color: Colors.white70))),
                      Expanded(child: Text("Move-in Date", style: TextStyle(color: Colors.white70))),
                      SizedBox(width: 60, child: Text("Actions", style: TextStyle(color: Colors.white70))),
                    ],
                  ),

                  // Tenant list from Firebase
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('tenants').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final tenants = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: tenants.length,
                          itemBuilder: (context, index) {
                            final tenantDoc = tenants[index];
                            var data = tenantDoc.data() as Map<String, dynamic>;
                            final docId = tenantDoc.id; // Get the document ID

                            final unit = data['unit'] ?? 'N/A';
                            final name = data['name'] ?? 'Unknown';
                            final email = data['email'] ?? 'noemail@domain.com';
                            final moveInDate = formatTimestamp(data['moveInDate']);

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(child: Text("Unit $unit", style: const TextStyle(color: Colors.white))),
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
                                  Expanded(
                                    child: Text(moveInDate, style: const TextStyle(color: Colors.white)),
                                  ),
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
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Confirm Delete'),
                                                content: const Text('Are you sure you want to delete this tenant?'),
                                                actions: [
                                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                                                ],
                                              ),
                                            );

                                            if (confirm == true) {
                                              // perform deletion
                                              await FirebaseFirestore.instance.collection('tenants').doc(docId).delete();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Tenant deleted')),
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
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}