import 'package:flutter/material.dart';

class TenantScreenDesktopTablet extends StatelessWidget {
  const TenantScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tenant Management',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white)),
                  const SizedBox(height: 20),
                  const InviteSection(),
                  const SizedBox(height: 20),
                  const Expanded(child: TenantsTable()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class Sidebar extends StatelessWidget {
  final List<Map<String, String>> menuItems = [
    {'title': 'Dashboard', 'icon': 'assets/icon_assets/House_01.png'},
    {'title': 'Tenants', 'icon': 'assets/icon_assets/Users_Group.png'},
    {'title': 'Chats', 'icon': 'assets/icon_assets/Chat_Circle.png'},
    {'title': 'Bills & Payments', 'icon': 'assets/icon_assets/Credit_Card_02.png'},
    {'title': 'Announcements', 'icon': 'assets/icon_assets/User_Voice.png'},
    {'title': 'Reports', 'icon': 'assets/icon_assets/Octagon_Warning.png'},
    {'title': 'Analytics', 'icon': 'assets/icon_assets/Chart_Line.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      color: Colors.black87,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Center(
              child: Text(
                'Pinesville Properties',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: menuItems.map((item) {
                return ListTile(
                  leading: Image.asset(
                    item['icon']!,
                    width: 24,
                    height: 24,
                    color: Colors.white70,
                  ),
                  title: Text(
                    item['title']!,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () {},
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class InviteSection extends StatelessWidget {
  const InviteSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Invite link',
                labelStyle: const TextStyle(color: Colors.white70),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: const Color(0xFF2C2C2C),
              ),
              controller: TextEditingController(
                  text: "https://pinesville/invite/link/1jahbi..."),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(onPressed: () {}, child: const Text("Copy Link")),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email Address',
                labelStyle: const TextStyle(color: Colors.white70),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: const Color(0xFF2C2C2C),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(onPressed: () {}, child: const Text("Send Link")),
        ],
      ),
    );
  }
}

class TenantsTable extends StatelessWidget {
  const TenantsTable({super.key});

  final List<Map<String, String>> tenants = const [
    {'name': 'Ralph Edwards', 'unit': 'Unit 101', 'date': '05/06/2025'},
    {'name': 'Ralph Edwards', 'unit': 'Unit 102', 'date': '05/06/2025'},
    {'name': 'Ralph Edwards', 'unit': 'Unit 201', 'date': '05/06/2025'},
    {'name': 'Ralph Edwards', 'unit': 'Unit 202', 'date': '05/04/2025'},
    {'name': 'Ralph Edwards', 'unit': 'Unit 203', 'date': '05/06/2025'},
    {'name': 'Ralph Edwards', 'unit': 'Unit 301', 'date': '05/06/2025'},
    {'name': 'Ralph Edwards', 'unit': 'Unit 107', 'date': '05/06/2025'},
    {'name': 'Ralph Edwards', 'unit': 'Unit 108', 'date': '05/06/2025'},
    {'name': 'Ralph Edwards', 'unit': 'Unit 109', 'date': '05/04/2025'},
    {'name': 'Ralph Edwards', 'unit': 'Unit 110', 'date': '05/06/2025'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.pending),
              label: const Text("Pending Applications"),
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.black),
              dataRowColor: MaterialStateProperty.all(const Color(0xFF2C2C2C)),
              columnSpacing: 60,
              columns: const [
                DataColumn(label: Text('Name', style: TextStyle(color: Colors.white))),
                DataColumn(label: Text('Unit', style: TextStyle(color: Colors.white))),
                DataColumn(label: Text('Move-in Date', style: TextStyle(color: Colors.white))),
                DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white))),
              ],
              rows: tenants
                  .map(
                    (tenant) => DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/icon_assets/Users_Group-1.png'), // Replace with your asset path
                            radius: 16,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            tenant['name']!,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(tenant['unit']!, style: const TextStyle(color: Colors.white70))),
                    DataCell(Text(tenant['date']!, style: const TextStyle(color: Colors.white70))),
                    DataCell(Row(
                      children: const [
                        Icon(Icons.open_in_new, color: Colors.white70, size: 18),
                        SizedBox(width: 10),
                        Icon(Icons.delete_outline, color: Colors.white70, size: 18),
                      ],
                    )),
                  ],
                ),
              )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
