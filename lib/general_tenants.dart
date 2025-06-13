import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webadmin_pinesville/menu.dart';
import 'package:webadmin_pinesville/pending_applications.dart';
import 'package:webadmin_pinesville/tenant_screen.dart';

class GeneralTenantsScreen extends StatefulWidget {
  const GeneralTenantsScreen({super.key});

  @override
  State<GeneralTenantsScreen> createState() => _GeneralTenantsScreenState();
}

class _GeneralTenantsScreenState extends State<GeneralTenantsScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  String searchText = '';
  bool sortAscending = true;

  String formatTimestamp(dynamic value) {
    if (value is Timestamp) {
      final date = value.toDate();
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }
    return 'N/A';
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Pages / Tenant Management',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
                  ),
                  Text(
                    'Tenant Management',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildInviteSection(context),
                  const SizedBox(height: 30),

                  _buildSearchAndActions(),
                  const SizedBox(height: 20),

                  _buildTableHeader(),
                  Expanded(child: _buildTenantList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInviteSection(BuildContext context) {
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
                  style: const TextStyle(color: Colors.white),
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
                  // TODO: Send invite logic
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

  Widget _buildSearchAndActions() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchText = value.toLowerCase();
              });
            },
            style: const TextStyle(color: Colors.white),
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
          onPressed: () {
            setState(() {
              sortAscending = !sortAscending;
            });
          },
          icon: const Icon(Icons.sort),
          label: Text('Sort by Unit No. (${sortAscending ? "ASC" : "DESC"})'),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: const [
          Expanded(child: Text("Unit", style: TextStyle(color: Colors.white70))),
          Expanded(child: Text("Name", style: TextStyle(color: Colors.white70))),
          Expanded(child: Text("Move-in Date", style: TextStyle(color: Colors.white70))),
          SizedBox(width: 60, child: Text("Actions", style: TextStyle(color: Colors.white70))),
        ],
      ),
    );
  }

  Widget _buildTenantList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        List<QueryDocumentSnapshot> tenants = snapshot.data!.docs;

        // Apply search
        if (searchText.isNotEmpty) {
          tenants = tenants.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final name = "${data['FirstName'] ?? ''} ${data['LastName'] ?? ''}".toLowerCase();
            final unit = (data['UnitNo'] ?? '').toString().toLowerCase();
            return name.contains(searchText) || unit.contains(searchText);
          }).toList();
        }

        // Sort by UnitNo numerically
        tenants.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;

          final aUnit = int.tryParse((aData['UnitNo'] ?? '').toString()) ?? 0;
          final bUnit = int.tryParse((bData['UnitNo'] ?? '').toString()) ?? 0;

          return sortAscending ? aUnit.compareTo(bUnit) : bUnit.compareTo(aUnit);
        });

        return ListView.builder(
          itemCount: tenants.length,
          itemBuilder: (context, index) {
            final doc = tenants[index];
            final data = doc.data() as Map<String, dynamic>;
            final docId = doc.id;

            final unit = data['UnitNo'] ?? 'N/A';
            final name = "${data['FirstName'] ?? ''} ${data['LastName'] ?? ''}".trim();
            final email = data['Email'] ?? 'noemail@domain.com';
            final profilePicUrl = data['ProfilePic'] ?? '';
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
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(profilePicUrl),
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
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: const Color(0xFF1E1E1E),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                title: const Text('Confirm Deletion', style: TextStyle(color: Colors.white)),
                                content: const Text(
                                  'Are you sure you want to delete this tenant? This action cannot be undone.',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              try {
                                final userData = doc.data() as Map<String, dynamic>;
                                final unitNo = userData['UnitNo'];

                                // Move tenant to archived_Users
                                await FirebaseFirestore.instance.collection('archived_Users').doc(docId).set(userData);

                                // Delete from Users
                                await FirebaseFirestore.instance.collection('Users').doc(docId).delete();

                                // Find the matching unit and clear tenantId + set status to 'Vacant'
                                final query = await FirebaseFirestore.instance
                                    .collection('units')
                                    .where('unitNumber', isEqualTo: unitNo)
                                    .get();

                                for (var unitDoc in query.docs) {
                                  await unitDoc.reference.update({
                                    'tenantId': null,
                                    'status': 'Vacant',
                                  });
                                }

                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tenant deleted')));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                              }
                            }
                          }
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
