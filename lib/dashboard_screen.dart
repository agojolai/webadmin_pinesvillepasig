import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'menu.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Row(
        children: [
          SidebarMenu(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pages / Dashboard',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 0),
                  Text(
                    'Dashboard',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTopCards(),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _AnnouncementsSection()),
                      const SizedBox(width: 16),
                      Expanded(flex: 3, child: _LineChartCard()),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _TenantsListCard()),
                      const SizedBox(width: 14),
                      Expanded(flex: 3, child: _ReportsSection()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<double> _fetchTotalRentRemaining() async {
    double totalUnpaid = 0.0;

    final unitsSnapshot = await FirebaseFirestore.instance.collection('units').get();

    for (final unit in unitsSnapshot.docs) {
      final billsSnapshot = await unit.reference.collection('Bills').get();

      for (final bill in billsSnapshot.docs) {
        final data = bill.data();
        if (data['status'] == 'unpaid') {
          totalUnpaid += (data['totalAmount'] ?? 0).toDouble();
        }
      }
    }

    return totalUnpaid;
  }

  Widget _buildTopCards() {
    return FutureBuilder<List<Object>>(
      future: Future.wait([
        FirebaseFirestore.instance.collection('Users').get(),
        FirebaseFirestore.instance.collection('pendingTenants').get(),
        _fetchTotalRentRemaining(),
      ]),
      builder: (context, snapshot) {
        int tenantCount = 0;
        int pendingCount = 0;
        double rentRemaining = 0;

        if (snapshot.hasData) {
          final usersSnapshot = snapshot.data![0] as QuerySnapshot;
          final pendingSnapshot = snapshot.data![1] as QuerySnapshot;
          final rent = snapshot.data![2] as double;

          tenantCount = usersSnapshot.docs.length;
          pendingCount = pendingSnapshot.docs.length;
          rentRemaining = rent;
        }

        final cardData = [
          {
            'title': 'Rent Collected',
            'value': '12,045',
            'icon': Icons.attach_money
          },
          {
            'title': 'Rent Remaining',
            'value': rentRemaining.toStringAsFixed(2),
            'icon': Icons.money_off
          },
          {
            'title': 'Paid Tenants',
            'value': '5',
            'icon': Icons.check_circle
          },
          {
            'title': 'Tenants',
            'value': '$tenantCount',
            'icon': Icons.people
          },{
            'title': 'Pending Tenants',
            'value': '$pendingCount',
            'icon': Icons.person_add_rounded
          },
        ];

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(cardData.length, (index) {
            final data = cardData[index];
            return Expanded(
              child: Container(
                height: 109,
                margin: EdgeInsets.only(right: index < cardData.length - 1 ? 12 : 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(data['icon'] as IconData, color: Colors.orange, size: 34), // Larger icon
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14, // Larger title
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            data['value'] as String,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 22, // Larger value
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _AnnouncementsSection extends StatelessWidget {
  Stream<DocumentSnapshot<Map<String, dynamic>>> latestAnnouncementStream() {
    return FirebaseFirestore.instance
        .collection('announcements')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.first);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          const Text(
            "Announcement",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Announcement Card
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: latestAnnouncementStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              }

              if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                return const Text(
                  "No announcements available",
                  style: TextStyle(color: Colors.white70),
                );
              }

              final data = snapshot.data!.data()!;
              final subject = data['title'] ?? 'No Subject';
              final recipient = data['recipient'] ?? 'Everyone';
              final message = data['message'] ?? 'No message';
              final timestamp = data['timestamp'] != null
                  ? (data['timestamp'] as Timestamp).toDate()
                  : DateTime.now();

              final timeAgo = timeago.format(timestamp);

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subject and Timestamp
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subject,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          timeAgo,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Message
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Recipient aligned right
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        recipient,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LineChartCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Line Chart', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Expanded(
            child: Center(
              child: Text('Chart placeholder', style: TextStyle(color: Colors.white54)),
            ),
          )
        ],
      ),
    );
  }
}

class _TenantsListCard extends StatelessWidget {
  const _TenantsListCard({super.key});

  // Fetch all documents in 'Users' collection
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchTenants() {
    return FirebaseFirestore.instance.collection('Users').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tenants',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 0),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: fetchTenants(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.orange));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No tenants found.', style: TextStyle(color: Colors.white54)),
                  );
                }

                final tenants = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: tenants.length,
                  itemBuilder: (context, index) {
                    final data = tenants[index].data();
                    final fullName = '${data['FirstName'] ?? ''} ${data['LastName'] ?? ''}';
                    final unitNo = data['UnitNo'] ?? 'N/A';
                    final photoUrl = data['ImageUrl'] ?? '';

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: photoUrl.isNotEmpty
                                ? NetworkImage(photoUrl)
                                : const AssetImage('assets/images/default_profile.png') as ImageProvider,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fullName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Unit $unitNo',
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.more_vert, color: Colors.white54),
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
    );
  }
}

class _ReportsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reports = [
      {"name": "Andrew Tate", "status": "In Progress", "category": "Maintenance", "date": "10 April 2025"},
      {"name": "Andrew Tate", "status": "In Progress", "category": "Maintenance", "date": "10 April 2025"},
      {"name": "Andrew Tate", "status": "In Progress", "category": "Maintenance", "date": "10 April 2025"},
    ];

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tenants Reports",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: reports.map((report) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text(report['name']!, style: const TextStyle(color: Colors.white))),
                      Expanded(flex: 2, child: Text(report['status']!, style: const TextStyle(color: Colors.white))),
                      Expanded(flex: 2, child: Text(report['category']!, style: const TextStyle(color: Colors.white))),
                      Expanded(flex: 2, child: Text(report['date']!, style: const TextStyle(color: Colors.white))),
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
