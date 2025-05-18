import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PendingApplicationsScreen extends StatelessWidget {
  const PendingApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111111),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(25),
            child: Row(
              children: [
                //SidebarMenu(),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tenant Management',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Manage your tenants or invite new tenants to your residence',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFA9A9A9),
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 1860,
                            height: 922,
                            decoration: BoxDecoration(
                              color: const Color(0xFF282828),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Back Button
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.arrow_back,
                                                color: Colors.white),
                                            onPressed: () => Get.back(),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "Back",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),

                                      // Title
                                      const Text(
                                        "Pending Applications",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      // Search + Filter Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(8),
                                                hintText:
                                                    'Search by name or email',
                                                filled: true,
                                                fillColor: Colors.grey[900],
                                                prefixIcon: const Icon(
                                                    Icons.search,
                                                    color: Colors.white),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: BorderSide.none,
                                                ),
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          ElevatedButton.icon(
                                            onPressed: () {},
                                            icon: const Icon(Icons.filter_list),
                                            label: const Text("Filter"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey[800],
                                              foregroundColor: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),

                                      // Table Header
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Expanded(
                                              child: Text("Name",
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          Expanded(
                                              child: Text("Email",
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          Expanded(
                                              child: Text("Phone Number",
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          Expanded(
                                              child: Text("Unit No.",
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          Expanded(
                                              child: Text("Move-in Date",
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          Expanded(
                                              child: Text("Actions",
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                        ],
                                      ),
                                      const Divider(color: Colors.grey),

                                      // Firestore Data Stream
                                      SizedBox(
                                        height: 600,
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection('pendingTenants').snapshots(),
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
                                                final docId = tenantDoc.id;
                                                final unit = data['UnitNo'] ?? 'N/A';
                                                final firstname = data['FirstName'] ?? 'Unknown';
                                                final lastname = data['LastName'] ?? 'Unknown';
                                                final name = '$firstname $lastname';
                                                final email = data['Email'] ?? 'noemail@domain.com';
                                                final moveInDate = data['MoveInDate'] ?? 'No date';
                                                final phone = data['Phone'] ?? '';

                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(child: Text(name, style: const TextStyle(color: Colors.white))),
                                                        Expanded(child: Text(email, style: const TextStyle(color: Colors.white))),
                                                        Expanded(child: Text(phone, style: const TextStyle(color: Colors.white))),
                                                        Expanded(child: Text(unit, style: const TextStyle(color: Colors.white))),
                                                        Expanded(child: Text(moveInDate, style: const TextStyle(color: Colors.white))),
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () async {
                                                                  final confirm = await showDialog<bool>(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return AlertDialog(
                                                                        backgroundColor: const Color(0xFF282828),
                                                                        title: const Text("Confirm Approval", style: TextStyle(color: Colors.white70)),
                                                                        content: Text("Are you sure you want to approve $name's application?",
                                                                            style: const TextStyle(color: Colors.white70)),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () => Navigator.of(context).pop(false),
                                                                            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
                                                                          ),
                                                                          TextButton(
                                                                            onPressed: () => Navigator.of(context).pop(true),
                                                                            child: const Text("Approve", style: TextStyle(color: Colors.green)),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );

                                                                  if (confirm == true) {
                                                                    // Move to 'Users'
                                                                    await FirebaseFirestore.instance.collection('Users').doc(docId).set(data);
                                                                    // Delete from 'pendingTenants'
                                                                    await FirebaseFirestore.instance.collection('pendingTenants').doc(docId).delete();

                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      SnackBar(
                                                                        content: Text('$name\'s application has been approved'),
                                                                        backgroundColor: Colors.green,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                                                child: const Text("Approve", style: TextStyle(color: Colors.white)),
                                                              ),
                                                              const SizedBox(width: 8),
                                                              ElevatedButton(
                                                                onPressed: () async {
                                                                  final confirm = await showDialog<bool>(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return AlertDialog(
                                                                        backgroundColor: const Color(0xFF282828),
                                                                        title: const Text("Confirm Decline", style: TextStyle(color: Colors.white70)),
                                                                        content: Text("Are you sure you want to decline $name's application?",
                                                                            style: const TextStyle(color: Colors.white70)),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () => Navigator.of(context).pop(false),
                                                                            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
                                                                          ),
                                                                          TextButton(
                                                                            onPressed: () => Navigator.of(context).pop(true),
                                                                            child: const Text("Decline", style: TextStyle(color: Colors.red)),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );

                                                                  if (confirm == true) {
                                                                    // Just delete from pendingTenants
                                                                    await FirebaseFirestore.instance.collection('pendingTenants').doc(docId).delete();

                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      SnackBar(
                                                                        content: Text('$name\'s application has been declined'),
                                                                        backgroundColor: Colors.red.shade900,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900),
                                                                child: const Text("Decline", style: TextStyle(color: Colors.white)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Divider(color: Color(0xFF454343)),
                                                  ],
                                                );

                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ))
                      ],
                    )
                  ],
                ))
              ],
            )),
      ),
    );
  }
}
