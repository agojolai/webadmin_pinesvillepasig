import 'package:flutter/material.dart';
import 'menu.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

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
                children: [
                  Text(
                    'Pages / Chats',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 0),
                  Text(
                    'Chats',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Row(
                      children: [
                        // Chat List Panel
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                // Search bar
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const TextField(
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.search, color: Colors.white),
                                      hintText: 'Search by chats and people',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Chat tiles
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                                        leading: CircleAvatar(
                                          backgroundImage: AssetImage('assets/avatar.jpg'),
                                        ),
                                        title: Text(
                                          'Ralph Edwards',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          'Let\'s see the...',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        trailing: Text(
                                          '12:35',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Chat Conversation Panel
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Header
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage('assets/avatar.jpg'),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Ralph Edwards',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.grey),
                                // Message area (empty for now)
                                Expanded(child: Container()),
                                // Message input
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[900],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: const TextField(
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            hintText: 'Type your message...',
                                            hintStyle: TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.attach_file, color: Colors.grey),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.mic, color: Colors.grey),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.send, color: Colors.orange[400]),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Info Panel
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('assets/avatar.jpg'),
                                  radius: 30,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Ralph Edwards\nUnit 101',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 16),
                                // Tenant Info
                                buildInfoRow('Email:', 'juanedelacruz@gmail.com'),
                                buildInfoRow('Contact Number:', '(+63) 09123456789'),
                                buildInfoRow('Move-in Date:', 'January 10, 2025'),
                                const SizedBox(height: 16),
                                // Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.add, size: 16),
                                      label: Text("Add Details"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[800],
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.person_remove, size: 16),
                                      label: Text("Remove"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[800],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Pendings
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Pendings',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                buildPendingItem('Plumbing', 'January 4, 2025'),
                                buildPendingItem('Refund', 'January 6, 2025'),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ',
              style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPendingItem(String title, String date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.check_box, color: Colors.green),
        ],
      ),
    );
  }
}
