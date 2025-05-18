import 'package:flutter/material.dart';
import 'menu.dart';

class TenantsScreen extends StatelessWidget {
  const TenantsScreen({super.key});

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
                  Text('Pages / Tenants',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[400])),
                  SizedBox(height: 0),
                  Text('Tenants',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 30),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(flex: 1, child: _buildTenantInfoCard()),
                              SizedBox(width: 18),
                              Expanded(flex: 2, child: _buildTransactionHistoryCard()),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(flex: 1, child: _buildOtherOccupantsCard()),
                              SizedBox(width: 24),
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

  Widget _buildTenantInfoCard() {
    return _buildCard(
      SizedBox(
        height: 300, // ✅ Set fixed height
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tenant Information",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                ),
                title: Text("Juan Dela Cruz", style: TextStyle(color: Colors.white)),
                subtitle: Text("juan.delacruz@gmail.com", style: TextStyle(color: Colors.grey)),
              ),
              SizedBox(height: 16),
              _infoRow("Unit", "101"),
              _infoRow("Username", "Username"),
              _infoRow("Contact Number", "Contact Number"),
              _infoRow("Move-in Date", "Move-in Date"),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                ),
                onPressed: () {},
                child: Text("Transfer Tenant"),
              ),
            ],
          ),
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
          Text(label, style: TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildTransactionHistoryCard() {
    return _buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transaction History",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),

          // Header Row with light background
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0), // 👈 indent Date Paid
                    child: Text(
                      "Date Paid",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Amount",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Reference Id",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          // Data rows
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0), // 👈 match indent
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
          Text("Other Unit Occupants", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Divider(color: Colors.grey),
          ...List.generate(
            3,
                (index) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.grey[700],
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text("Occupant ${index + 1}", style: TextStyle(color: Colors.white)),
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
          Text("Submeter Reading History", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Divider(color: Colors.grey),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text("12/14/2025", style: TextStyle(color: Colors.white)),
                  subtitle: Text("Water: 1000.00", style: TextStyle(color: Colors.grey)),
                  trailing: Text("kWh: 1295.25", style: TextStyle(color: Colors.grey)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}