import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'menu.dart';
import 'tenants_screen.dart';

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

    final chatRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(selectedChatId);

    // Ensure the chat document exists
    final chatDoc = await chatRef.get();
    if (!chatDoc.exists) {
      await chatRef.set({
        'createdAt': FieldValue.serverTimestamp(),
        'participants': [senderId, selectedTenantData?['uid']],
      });
    }

    await chatRef.collection('messages').add({
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
                  Text('Pages / Chats',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[400])),
                  Text('Chats',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
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
                                    stream: FirebaseFirestore.instance.collection('Users').snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(child: CircularProgressIndicator());
                                      }

                                      final users = snapshot.data!.docs;

                                      return ListView.builder(
                                        itemCount: users.length,
                                        itemBuilder: (context, index) {
                                          final user = users[index];
                                          final data = user.data() as Map<String, dynamic>;

                                          final String fullName = "${data['FirstName']} ${data['LastName']}";
                                          final String email = data['Email'] ?? '';
                                          final String profilePic = data['ProfilePic'] ?? '';
                                          final String userId = user.id;

                                          return ListTile(
                                            contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                            leading: CircleAvatar(
                                              backgroundImage: profilePic.isNotEmpty
                                                  ? NetworkImage(profilePic)
                                                  : const AssetImage('assets/avatar.jpg') as ImageProvider,
                                            ),
                                            title: Text(fullName, style: const TextStyle(color: Colors.white)),
                                            subtitle: Text(email, style: const TextStyle(color: Colors.grey)),
                                            onTap: () {
                                              setState(() {
                                                selectedChatId = 'chat_$userId';
                                                selectedTenantData = {
                                                  'uid': userId,
                                                  'name': fullName,
                                                  'email': email,
                                                  'contactNumber': data['Phone'] ?? '',
                                                  'unit': data['UnitNo'] ?? '',
                                                  'moveInDate': data['MoveInDate'],
                                                  'profilePic': profilePic,
                                                };
                                              });
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

                        // Chat Panel
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
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: selectedTenantData?['profilePic'] != null
                                          ? NetworkImage(selectedTenantData!['profilePic'])
                                          : const AssetImage('assets/avatar.jpg') as ImageProvider,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      selectedTenantData?['name'] ?? 'Select a chat',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.grey),
                                Expanded(
                                  child: selectedChatId == null
                                      ? const Center(child: Text('Select a chat to view messages', style: TextStyle(color: Colors.white54)))
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
                                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(vertical: 4),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: isMe ? Colors.orange[400] : Colors.grey[800],
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[900],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                    IconButton(icon: const Icon(Icons.attach_file, color: Colors.grey), onPressed: () {}),
                                    IconButton(icon: const Icon(Icons.mic, color: Colors.grey), onPressed: () {}),
                                    IconButton(icon: Icon(Icons.send, color: Colors.orange[400]), onPressed: () => sendMessage(_controller.text)),
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
                                ? const Center(child: Text('No tenant selected', style: TextStyle(color: Colors.white54)))
                                : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage: selectedTenantData?['profilePic'] != null
                                      ? NetworkImage(selectedTenantData!['profilePic'])
                                      : const AssetImage('assets/avatar.jpg') as ImageProvider,
                                  radius: 30,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${selectedTenantData?['name'] ?? ''}\n${selectedTenantData?['unit'] ?? ''}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 16),
                                buildInfoRow('Email:', selectedTenantData?['email'] ?? '-'),
                                buildInfoRow('Contact Number:', selectedTenantData?['contactNumber'] ?? '-'),
                                buildInfoRow(
                                  'Move-in Date:',
                                  selectedTenantData?['moveInDate'] is String
                                      ? selectedTenantData!['moveInDate']
                                      : '-',
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    if (selectedTenantData != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TenantsScreen(tenantId: selectedTenantData!['uid']),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.visibility, size: 16),
                                  label: const Text("View Tenant"),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
                                ),
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
          Text('$label ', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}