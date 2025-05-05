import 'package:flutter/material.dart';
import 'package:webadmin_pinesville/data/features.authentication/screens/responsive_screens/sidebar_menu.dart';

class TenantScreenDesktopTablet extends StatelessWidget {
  const TenantScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      body: Row(
        children: [
          SidebarMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(
                  'Pages / Tenants',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
                  SizedBox(height: 0),
                  Text(
                    'Tenant Management',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,fontWeight: FontWeight.bold,)
                  ),
                  SizedBox(height: 0),
                  Text(
                    'Manage your tenants or invite new tenants to your residence',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(height: 30),
                  InviteSection(),
                  const SizedBox(height: 20),
                  Expanded(child: TenantsTable()),
                ],
              ),
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
  final List<Map<String, String>> tenants = List.generate(
    10,
        (index) => {
      'name': 'Ralph Edwards',
      'email': 'ralphedwards$index@gmail.com',
      'unit': 'Unit 10${index + 1}',
      'date': '05/06/2025',
    },
  );

  final List<String> filterOptions = ['All', 'Active', 'Pending', 'Archived'];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
        'Tenant',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 16),

          // 🔍 Search & Filter Row
          Row(
            children: [
              // Search Field
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by name or email',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white10,
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIconColor: Colors.white54,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    // TODO: Implement filtering logic
                  },
                ),
              ),
              SizedBox(width: 16),
              // Filter Dropdown
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<String>(
                  dropdownColor: Colors.grey[900],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.white70,
                  hint: Text("Filter status", style: TextStyle(color: Colors.white54)),
                  items: filterOptions.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // TODO: Apply filtering based on status
                  },
                ),
              ),
              Spacer(),
              // Pending Applications Button
              ElevatedButton.icon(
                icon: Icon(Icons.pending),
                label: Text("Pending Applications"),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 10),

          // 🔽 Table
          Expanded(
            child: SingleChildScrollView(
              child: DataTableTheme(
                data: DataTableThemeData(
                  headingTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  dataTextStyle: TextStyle(color: Colors.white70),
                  dividerThickness: 0.5,
                ),
                child: DataTable(
                  columnSpacing: 24,
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Unit')),
                    DataColumn(label: Text('Move-in Date')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: tenants.map((tenant) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage('assets/images/avatar.png'),
                                radius: 16,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    tenant['name']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    tenant['email']!,
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(tenant['unit']!)),
                        DataCell(Text(tenant['date']!)),
                        DataCell(
                          Row(
                            children: const [
                              Icon(Icons.open_in_new, color: Colors.white70, size: 18),
                              SizedBox(width: 10),
                              Icon(Icons.delete_outline, color: Colors.white70, size: 18),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
