import 'package:flutter/material.dart';

import 'menu.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.white, fontSize: 14);
    final columnTitles = ["Unit No.", "Type", "Report Date", "Description", "Status"];

    final rows = List.generate(16, (index) {
      return {
        'unit': '101',
        'type': ['Plumbing', 'Electrical', 'Pest Control', 'Other'][index % 4],
        'date': 'January 10, 2025',
        'description': 'Lorem ipsum sit amet',
        'status': ['Pending', 'In Progress', 'Completed'][index % 3],
      };
    });

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
                  Text('Pages / Reports',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[400])),
                  const SizedBox(height: 0),
                  Text('Reports',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),

                  // Filter button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E1E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list),
                      label: const Text("Filter"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Table header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
                      color: const Color(0xFF1E1E1E),
                    ),
                    child: Row(
                      children: columnTitles.map((title) {
                        return Expanded(
                          flex: title == "Description" ? 3 : 2,
                          child: Text(title, style: textStyle.copyWith(fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                    ),
                  ),

                  // Table rows
                  Expanded(
                    child: ListView.builder(
                      itemCount: rows.length,
                      itemBuilder: (context, index) {
                        final row = rows[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          decoration: BoxDecoration(
                              color: const Color(0xFF121212)
                          ),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text(row['unit']!, style: textStyle)),
                              Expanded(flex: 2, child: Text(row['type']!, style: textStyle)),
                              Expanded(flex: 2, child: Text(row['date']!, style: textStyle)),
                              Expanded(flex: 3, child: Text(row['description']!, style: textStyle)),
                              Expanded(
                                flex: 2,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    dropdownColor: const Color(0xFF1E1E1E),
                                    value: row['status'],
                                    items: ['Pending', 'In Progress', 'Completed']
                                        .map((status) => DropdownMenuItem(
                                      value: status,
                                      child: Text(status, style: textStyle),
                                    ))
                                        .toList(),
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
