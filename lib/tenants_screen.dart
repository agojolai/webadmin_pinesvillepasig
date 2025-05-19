import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'menu.dart';

class TenantsScreen extends StatelessWidget {
  final String tenantId;

  const TenantsScreen({super.key, required this.tenantId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('Users').doc(tenantId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Color(0xFF121212),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final name = "${data['FirstName'] ?? ''} ${data['LastName'] ?? ''}".trim();
        final email = data['Email'] ?? 'No email';
        final unit = data['UnitNo'] ?? 'N/A';
        final contactNumber = data['Phone'] ?? 'N/A';
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context); // Go back to UnitsScreen
                                },
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pages / Tenants',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.grey[400]),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tenants',
                                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(flex: 1, child: _buildTenantInfoCard(name, email, unit, moveInDate, contactNumber, profilePicUrl)),
                                  const SizedBox(width: 18),
                                  Expanded(flex: 2, child: _buildTransactionHistoryCard()),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(flex: 1, child: _buildOtherOccupantsCard()),
                                  const SizedBox(width: 24),
                                  Expanded(flex: 2, child: _buildSubmeterReadingCard()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildTenantInfoCard(String name, String email, String unit, String moveInDate, String contactNumber, String profilePicUrl) {
    return _buildCard(
      SizedBox(
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tenant Information",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 24,
                          backgroundImage: NetworkImage(profilePicUrl)  as ImageProvider
                      ),
                      title: Text(name, style: const TextStyle(color: Colors.white)),
                      subtitle: Text(email, style: const TextStyle(color: Colors.grey)),
                    ),
                    const SizedBox(height: 12),
                    _infoRow("Unit", unit),
                    _infoRow("Username", name),
                    _infoRow("Contact Number", contactNumber),
                    _infoRow("Move-in Date", moveInDate),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
              ),
              onPressed: () {},
              child: const Text("Transfer Tenant"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildTransactionHistoryCard() {
    return _buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Transaction History",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Date Paid", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text("Amount", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  flex: 1,
                  child: Text("Reference Id", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("12/14/2025", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("₱ 3,025.00", style: TextStyle(color: Colors.white)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("PY-2025-1024XXXX", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherOccupantsCard() {
    return _buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Other Unit Occupants", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ...List.generate(
            3,
                (index) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.grey[700],
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: Text("Occupant ${index + 1}", style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmeterReadingCard() {
    return _buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Submeter Reading History", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Expanded(child: Text("Date", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                Expanded(child: Text("Water", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                Expanded(child: Text("Electricity", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("12/10/2025", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Expanded(child: Text("25 m³", style: TextStyle(color: Colors.white))),
                      Expanded(child: Text("75 kWh", style: TextStyle(color: Colors.white))),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}