import 'package:flutter/material.dart';
import 'menu.dart'; // Your SidebarMenu

class BillsPaymentsScreen extends StatefulWidget {
  const BillsPaymentsScreen({super.key});

  @override
  State<BillsPaymentsScreen> createState() => _BillsPaymentsScreenState();
}

class _BillsPaymentsScreenState extends State<BillsPaymentsScreen> {
  int selectedTabIndex = 0;
  final List<String> tabs = ["Billings", "Payments", "Readings"];

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
                    'Pages / Bills & Payments',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bills & Payments',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Summary Cards
                  Wrap(
                    spacing: 120,
                    runSpacing: 16,
                    children: [
                      _buildSummaryCard("Total Rent Collected", "12,045", Icons.payments),
                      _buildSummaryCard("Total Rent Remaining", "12,045", Icons.money_off),
                      _buildSummaryCard("Total Paid Tenants", "5", Icons.check_circle),
                      _buildSummaryCard("Total Pending Tenants", "6", Icons.warning_amber),
                      _buildSummaryCard("Tenants", "16", Icons.group),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Card-style Tabs & Content
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0x00ff8049),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card-style Tab Buttons
                        Row(
                          children: List.generate(tabs.length, (index) {
                            final isSelected = selectedTabIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTabIndex = index;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.orange : const Color(0xFF1E1E1E),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? Colors.orange : Colors.grey[700]!,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    tabs[index],
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.grey[300],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 20),

                        // Title and Search
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tabs[selectedTabIndex],
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Manage your tenants bills or modify their payments",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 300,
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(color: Colors.grey[500]),
                                  filled: true,
                                  fillColor: Colors.grey[900],
                                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Tab Content
                        if (selectedTabIndex == 0) _buildBillingTable(),
                        if (selectedTabIndex == 1)
                          const Text("Payments table here", style: TextStyle(color: Colors.white)),
                        if (selectedTabIndex == 2)
                          const Text("Readings table here", style: TextStyle(color: Colors.white)),

                        const SizedBox(height: 20),

                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
                              child: const Text("Configure"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
                              child: const Text("Edit"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                              child: const Text("Save"),
                            ),
                          ],
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

  // Summary Card Widget
  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange, size: 28),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Billing Table Widget
  Widget _buildBillingTable() {
    final columns = ["Unit", "Rent", "Electricity", "Trash Fee", "Wi-Fi", "Water", "Parking", "Extra", "Total"];
    final data = List.generate(9, (index) {
      return [
        "10${index + 1}",
        "3,500", "1,500", "1,500", "1,700",
        "800", "350", "150", "\$\$\$"
      ];
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateColor.resolveWith((states) => Colors.grey[900]!),
        columns: columns
            .map((title) => DataColumn(
          label: Text(
            title,
            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
        ))
            .toList(),
        rows: data
            .map((row) => DataRow(
          cells: row
              .map((cell) => DataCell(
            Text(cell, style: const TextStyle(color: Colors.white)),
          ))
              .toList(),
        ))
            .toList(),
      ),
    );
  }
}
