import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'menu.dart';


class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {

  final TextEditingController _controller = TextEditingController();
  final String senderId = FirebaseAuth.instance.currentUser?.uid ?? 'user_1';

  String? selectedChatId;
  Map<String, dynamic>? selectedTenantData;

  void sendMessage(String text) async {
    if (text.trim().isEmpty || selectedChatId == null) return;

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(selectedChatId)
        .collection('messages')
        .add({
      'text': text,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _controller.clear();
  }

  Stream<QuerySnapshot> getMessages(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> fetchTenantData(String tenantId, String chatId) async {
    final tenantSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(tenantId)
        .get();

    if (tenantSnapshot.exists) {
      setState(() {
        selectedTenantData = tenantSnapshot.data();
        selectedChatId = chatId;
      });
    } else {
      setState(() {
        selectedTenantData = null;
        selectedChatId = null;
      });
    }
  }

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
                  Text(
                    'Pages / Chats',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
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
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('chats')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                      final chats = snapshot.data!.docs;
                                      return ListView.builder(
                                        itemCount: chats.length,
                                        itemBuilder: (context, index) {
                                          final chat = chats[index];
                                          final chatData = chat.data() as Map<String, dynamic>;
                                          final chatId = chat.id;
                                          final tenantId = chatData['tenantId'];

                                          return FutureBuilder<DocumentSnapshot>(
                                            future: FirebaseFirestore.instance.collection('tenants').doc(tenantId).get(),
                                            builder: (context, tenantSnapshot) {
                                              if (!tenantSnapshot.hasData) {
                                                return const ListTile(
                                                  title: Text('Loading...', style: TextStyle(color: Colors.white)),
                                                );
                                              }

                                              final tenantData = tenantSnapshot.data!.data() as Map<String, dynamic>?;
                                              final tenantName = tenantData?['name'] ?? 'Tenant';

                                              return ListTile(
                                                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                                leading: const CircleAvatar(
                                                  backgroundImage: AssetImage('assets/avatar.jpg'),
                                                ),
                                                title: Text(tenantName, style: const TextStyle(color: Colors.white)),
                                                subtitle: const Text(
                                                  'Tap to view conversation',
                                                  style: TextStyle(color: Colors.grey),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    selectedChatId = chatId;
                                                    selectedTenantData = tenantData;
                                                  });
                                                },
                                              );
                                            },
                                          );
                                        },
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
                                    const CircleAvatar(
                                      backgroundImage: AssetImage('assets/avatar.jpg'),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      selectedTenantData?['name'] ?? 'Select a chat',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.grey),

                                // Message area
                                Expanded(
                                  child: selectedChatId == null
                                      ? const Center(
                                      child: Text('Select a chat to view messages',
                                          style: TextStyle(color: Colors.white54)))
                                      : StreamBuilder<QuerySnapshot>(
                                    stream: getMessages(selectedChatId!),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                      final messages = snapshot.data!.docs;
                                      return ListView.builder(
                                        reverse: true,
                                        itemCount: messages.length,
                                        itemBuilder: (context, index) {
                                          final msg = messages[index];
                                          final isMe = msg['senderId'] == senderId;
                                          return Align(
                                            alignment: isMe
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: Container(
                                              margin:
                                              const EdgeInsets.symmetric(vertical: 4),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: isMe
                                                    ? Colors.orange[400]
                                                    : Colors.grey[800],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                msg['text'],
                                                style: const TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),

                                // Message input
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[900],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 12),
                                        child: TextField(
                                          controller: _controller,
                                          style: const TextStyle(color: Colors.white),
                                          decoration: const InputDecoration(
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
                                      onPressed: () => sendMessage(_controller.text),
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
                            child: selectedTenantData == null
                                ? const Center(
                                child: Text(
                                  'No tenant selected',
                                  style: TextStyle(color: Colors.white54),
                                ))
                                : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                  backgroundImage: AssetImage('assets/avatar.jpg'),
                                  radius: 30,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${selectedTenantData?['name'] ?? ''}\n${selectedTenantData?['unit'] ?? ''}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 16),
                                buildInfoRow('Email:',
                                    selectedTenantData?['email'] ?? '-'),
                                buildInfoRow('Contact Number:',
                                    selectedTenantData?['contactNumber'] ?? '-'),
                                buildInfoRow(
                                  'Move-in Date:',
                                  selectedTenantData?['moveInDate'] is Timestamp
                                      ? DateFormat.yMMMMd().format(
                                      (selectedTenantData!['moveInDate']
                                      as Timestamp)
                                          .toDate())
                                      : '-',
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // TODO: Navigate to tenant details
                                  },
                                  icon: const Icon(Icons.visibility, size: 16),
                                  label: const Text("View Tenant"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 16),
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
              style: const TextStyle(color: Colors.white, fontSize: 12),
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
                Text(date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.check_box, color: Colors.green),
        ],
      ),
    );
  }
}