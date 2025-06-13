import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_unit.dart';
import 'menu.dart';
import 'unit_details.dart';

class UnitsScreen extends StatefulWidget {
  const UnitsScreen({super.key});

  @override
  State<UnitsScreen> createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
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

  Future<Map<String, Map<String, dynamic>>> fetchUsersByUnitNo() async {
    final usersSnapshot = await FirebaseFirestore.instance.collection('Users').get();
    Map<String, Map<String, dynamic>> userMap = {};
    for (var doc in usersSnapshot.docs) {
      final data = doc.data();
      final unitNo = data['UnitNo'];
      if (unitNo != null) {
        userMap[unitNo.toString()] = {
          'tenantId': doc.id,
          'status': (data['status'] ?? '').toString().toLowerCase(),
        };
      }
    }
    return userMap;
  }

  Future<void> syncTenantIdsToUnits() async {
    final userMap = await fetchUsersByUnitNo();
    final unitsSnapshot = await FirebaseFirestore.instance.collection('units').get();

    for (var unitDoc in unitsSnapshot.docs) {
      final unitData = unitDoc.data();
      final unitNumber = unitData['unitNumber']?.toString();

      if (unitNumber != null && userMap.containsKey(unitNumber)) {
        final tenantId = userMap[unitNumber]!['tenantId'];
        if (unitData['tenantId'] != tenantId) {
          await unitDoc.reference.update({'tenantId': tenantId});
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    syncTenantIdsToUnits(); // Sync once on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Row(
        children: [
          SidebarMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pages / Unit Management',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[400])),
                  const SizedBox(height: 0),
                  Text('Unit Management',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
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
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => const CreateUnitDialog(),
                          );
                          setState(() {});
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
                        headerCell('Actions', flex: 1),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<Map<String, Map<String, dynamic>>>(
                      future: fetchUsersByUnitNo(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final userMap = userSnapshot.data ?? {};

                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('units').snapshots(),
                          builder: (context, unitSnapshot) {
                            if (unitSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (!unitSnapshot.hasData || unitSnapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text("No units found", style: TextStyle(color: Colors.white70)),
                              );
                            }

                            final units = unitSnapshot.data!.docs;

                            return ListView.builder(
                              itemCount: units.length,
                              itemBuilder: (context, index) {
                                final unitData = units[index].data() as Map<String, dynamic>;
                                final unitNumber = unitData['unitNumber']?.toString();
                                String status = 'Vacant';

                                if (unitNumber != null && userMap.containsKey(unitNumber)) {
                                  final tenantInfo = userMap[unitNumber]!;
                                  final tenantStatus = tenantInfo['status'];
                                  if (tenantStatus == 'reserved') {
                                    status = 'Reserved';
                                  } else if (tenantStatus == 'approved' || tenantStatus == 'active') {
                                    status = 'Occupied';
                                  }
                                }

                                return InkWell(
                                  onTap: () {
                                    final details = unitData['Details'] ?? {};
                                    showDialog(
                                      context: context,
                                      builder: (context) => UnitDetailsDialog(
                                        unitData: {
                                          'unitNumber': unitData['unitNumber'],
                                          'status': status,
                                          'unitType': unitData['Unit Type'],
                                          'price': unitData['price'],
                                          'Details': details,
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
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
                                            status,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: getStatusColor(status),
                                            ),
                                          ),
                                        ),
                                        cellText('₱${unitData['price'] ?? 0}', flex: 1),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit, color: Colors.orange),
                                                tooltip: 'Edit',
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) => CreateUnitDialog(
                                                      existingUnitRef: units[index].reference,
                                                      existingUnitData: unitData,
                                                    ),
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                                tooltip: 'Delete',
                                                onPressed: () async {
                                                  final confirm = await showDialog<bool>(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      backgroundColor: const Color(0xFF1E1E1E),
                                                      title: const Text("Delete Unit", style: TextStyle(color: Colors.white)),
                                                      content: const Text("Are you sure you want to delete this unit?",
                                                          style: TextStyle(color: Colors.white70)),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.of(context).pop(false),
                                                          child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                                                        ),
                                                        TextButton(
                                                          onPressed: () => Navigator.of(context).pop(true),
                                                          child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  if (confirm == true) {
                                                    await units[index].reference.delete();
                                                  }
                                                },
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
