import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webadmin_pinesville/menu.dart';
import 'package:webadmin_pinesville/create_unit.dart';
import 'package:webadmin_pinesville/tenants_screen.dart';

class UnitsScreen extends StatelessWidget {
  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Text('Pages / Units Management',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[400])),
                  const SizedBox(height: 4),
                  Text('Unit Management',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 4),
                  Text('View and edit all your units registered on your platform or Create new units.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[400])),
                  const SizedBox(height: 30),
                  _buildSearchAndActions(context, searchController),
                  const SizedBox(height: 20),
                  _buildTableHeader(),
                  const SizedBox(height: 8),
                  Expanded(child: _buildUnitTable()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndActions(BuildContext context, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Search by unit type or status...',
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
          onPressed: () {
            // TODO: Implement filter logic (e.g., show bottom sheet or dialog)
            showModalBottomSheet(
              context: context,
              backgroundColor: const Color(0xFF1E1E1E),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Filter Options', style: TextStyle(color: Colors.white, fontSize: 18)),
                      SizedBox(height: 12),
                      // Add dropdowns, switches, or chips for filtering here
                      Text('Coming soon...', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.filter_list),
          label: const Text('Filter'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF333333),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(context: context, builder: (_) => const CreateUnitDialog());
          },
          icon: const Icon(Icons.add),
          label: const Text('Add new units'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B00),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: const [
          Expanded(child: Text("Unit", style: TextStyle(color: Colors.white70))),
          Expanded(child: Text("Unit Type", style: TextStyle(color: Colors.white70))),
          Expanded(child: Text("Status", style: TextStyle(color: Colors.white70))),
          Expanded(child: Text("Price", style: TextStyle(color: Colors.white70))),
        ],
      ),
    );
  }

  Widget _buildUnitTable() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('units').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(color: Colors.grey),
          itemBuilder: (context, index) {
            final unit = docs[index].data() as Map<String, dynamic>;
            final status = unit['status'] ?? 'N/A';

            Color statusColor;
            switch (status) {
              case 'Vacant':
                statusColor = Colors.green;
                break;
              case 'Occupied':
                statusColor = Colors.grey;
                break;
              case 'Reserved':
                statusColor = Colors.orange;
                break;
              default:
                statusColor = Colors.blue;
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TenantsScreen(UnitNo: unit['unitNumber'], tenantId: ''),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(child: Text(unit['unitNumber'] ?? '-', style: const TextStyle(color: Colors.white))),
                    Expanded(child: Text(unit['Unit Type'] ?? '-', style: const TextStyle(color: Colors.white))),
                    Expanded(
                      child: Text(status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Expanded(
                        child: Text(unit['price']?.toString() ?? '0',
                            style: const TextStyle(color: Colors.white))),
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
