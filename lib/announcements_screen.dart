import 'package:flutter/material.dart';
import 'menu.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

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
                  'Pages / Announcements',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
                  SizedBox(height: 0),
                  Text(
                      'Announcements',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,fontWeight: FontWeight.bold,)
                  ),
                  SizedBox(height: 30),

                  Expanded(
                    child: Row(
                      children: [
                        // Left panel with announcements list
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                // Search bar
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A2A2A),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const TextField(
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.search, color: Colors.white),
                                      border: InputBorder.none,
                                      hintText: 'Search by chats and people',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // List of announcements
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: 6,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(vertical: 8),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF121212),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Plumbing',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  '10 min ago',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam malesuada ligula.',
                                              style: TextStyle(color: Colors.grey[400]),
                                            ),
                                            const SizedBox(height: 8),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text(
                                                'Ralph Edwards',
                                                style: TextStyle(color: Colors.grey[500]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // Compose button
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2A2A2A),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                    ),
                                    onPressed: () {},
                                    icon: const Icon(Icons.add, color: Colors.white),
                                    label: const Text(
                                      'Compose',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Right panel (currently empty in the screenshot)
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(16),
                            ),
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
}