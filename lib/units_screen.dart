import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_unit.dart';
import 'menu.dart';

class UnitsScreen extends StatelessWidget {
  const UnitsScreen({super.key});

  Color getStatusColor(String status) {
    switch (status) {
      case 'Vacant':
        return Colors.green;
      case 'Occupied':
        return Colors.red;
      case 'Reserved':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Row(
        children: [
          SidebarMenu(),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pages / Unit Management',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[400])),
                  const SizedBox(height: 0),

                  Text('Unit Management',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),

                  // Search and Add Button
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search by unit type and details...',
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: const Color(0xFF1E1E1E),
                            prefixIcon: const Icon(Icons.search, color: Colors.white54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const CreateUnitDialog(),
                          );
                        },
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text("Add new unit"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Table Headers
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        headerCell('Unit', flex: 1),
                        headerCell('Unit Type', flex: 2),
                        headerCell('Status', flex: 2),
                        headerCell('Price', flex: 1),
                      ],
                    ),
                  ),

                  // Firestore Data Table
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('units').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text("No units found", style: TextStyle(color: Colors.white70)),
                          );
                        }

                        final units = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: units.length,
                          itemBuilder: (context, index) {
                            final unitData = units[index].data() as Map<String, dynamic>;

                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.white12)),
                              ),
                              child: Row(
                                children: [
                                  cellText(unitData['unitNumber'] ?? '', flex: 1),
                                  cellText(unitData['Unit Type'] ?? '', flex: 2),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      unitData['status'] ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: getStatusColor(unitData['status'] ?? ''),
                                      ),
                                    ),
                                  ),
                                  cellText('${unitData['price'] ?? 0}', flex: 1),
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

  Widget headerCell(String title, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
      ),
    );
  }

  Widget cellText(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
