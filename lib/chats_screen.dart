import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'menu.dart';
import 'tenant_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});
  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final String senderId = FirebaseAuth.instance.currentUser?.uid ?? 'user_1';

  String? selectedChatId;
  String _searchQuery = '';
  Map<String, dynamic>? selectedTenantData;

  XFile? _selectedImageFile;
  Uint8List? _selectedImageBytes;
  bool _isSending = false;

  // ----------------------- Image Upload -----------------------

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImageFile = pickedFile;
        _selectedImageBytes = bytes;
      });
    }
  }

  Future<String?> uploadImageToFirebase() async {
    try {
      if (_selectedImageBytes == null) return null;
      final ref = FirebaseStorage.instance
          .ref()
          .child('chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await ref.putData(_selectedImageBytes!);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Upload failed: $e');
      return null;
    }
  }

  // ----------------------- Message Sending -----------------------

  Future<void> sendMessage(String text) async {
    if ((text.trim().isEmpty && _selectedImageBytes == null) ||
        selectedChatId == null || _isSending) return;

    setState(() => _isSending = true);

    final chatRef = FirebaseFirestore.instance.collection('chats').doc(selectedChatId);

    final chatDoc = await chatRef.get();
    if (!chatDoc.exists) {
      await chatRef.set({
        'createdAt': FieldValue.serverTimestamp(),
        'participants': [senderId, selectedTenantData?['uid']],
      });
    }

    String? imageUrl;
    if (_selectedImageBytes != null) {
      imageUrl = await uploadImageToFirebase();
    }

    await chatRef.collection('messages').add({
      'text': text,
      'imageUrl': imageUrl,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _controller.clear();
    setState(() {
      _selectedImageFile = null;
      _selectedImageBytes = null;
      _isSending = false;
    });
  }

  Stream<QuerySnapshot> getMessages(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // ----------------------- UI Widgets -----------------------

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

  Widget buildChatMessage(Map<String, dynamic> data, bool isMe) {
    final hasText = data.containsKey('text') && (data['text']?.toString().trim().isNotEmpty ?? false);
    final hasImage = data.containsKey('imageUrl') && (data['imageUrl']?.toString().isNotEmpty ?? false);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (hasImage)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isMe ? Colors.orange[400] : Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.network(data['imageUrl'], width: 200, height: 200, fit: BoxFit.cover),
            ),
          if (hasText)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isMe ? Colors.orange[400] : Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(data['text'], style: const TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ----------------------- Main Build -----------------------

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
                  Text('Pages / Chats', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[400])),
                  Text('Chats', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      children: [
                        buildChatList(),
                        const SizedBox(width: 12),
                        buildChatPanel(),
                        const SizedBox(width: 12),
                        buildTenantInfoPanel(),
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

  Widget buildChatList() {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.white),
                  hintText: 'Search by name or email',
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
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final users = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final fullName = "${data['FirstName']} ${data['LastName']}".toLowerCase();
                    final email = (data['Email'] ?? '').toString().toLowerCase();
                    return fullName.contains(_searchQuery) || email.contains(_searchQuery);
                  }).toList();

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final data = user.data() as Map<String, dynamic>;
                      final fullName = "${data['FirstName']} ${data['LastName']}";
                      final userId = user.id;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        leading: CircleAvatar(
                          backgroundImage: (data['ProfilePic']?.isNotEmpty ?? false)
                              ? NetworkImage(data['ProfilePic'])
                              : const AssetImage('assets/avatar.jpg') as ImageProvider,
                        ),
                        title: Text(fullName, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(data['Email'] ?? '', style: const TextStyle(color: Colors.grey)),
                        onTap: () {
                          setState(() {
                            selectedChatId = 'chat_$userId';
                            selectedTenantData = {
                              'uid': userId,
                              'name': fullName,
                              'email': data['Email'] ?? '',
                              'contactNumber': data['Phone'] ?? '',
                              'unit': data['UnitNo'] ?? '',
                              'moveInDate': data['MoveInDate'],
                              'profilePic': data['ProfilePic'] ?? '',
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
    );
  }

  Widget buildChatPanel() {
    return Expanded(
      flex: 4,
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: (selectedTenantData?['profilePic']?.isNotEmpty ?? false)
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
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final data = msg.data() as Map<String, dynamic>?;
                      if (data == null) return const SizedBox.shrink();
                      return buildChatMessage(data, data['senderId'] == senderId);
                    },
                  );
                },
              ),
            ),
            if (_selectedImageBytes != null) buildImagePreview(),
            buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget buildImagePreview() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey[900]),
        padding: const EdgeInsets.all(4),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(_selectedImageBytes!, height: 100, width: 100, fit: BoxFit.cover),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => setState(() {
                  _selectedImageFile = null;
                  _selectedImageBytes = null;
                }),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _controller,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        IconButton(icon: const Icon(Icons.insert_photo, color: Colors.grey), onPressed: pickImage),
        IconButton(
          icon: Icon(Icons.send,
              color: (_controller.text.trim().isEmpty && _selectedImageBytes == null)
                  ? Colors.grey
                  : Colors.orange[400]),
          onPressed: (_controller.text.trim().isEmpty && _selectedImageBytes == null)
              ? null
              : () => sendMessage(_controller.text),
        ),
      ],
    );
  }

  Widget buildTenantInfoPanel() {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
        child: selectedTenantData == null
            ? const Center(child: Text('No tenant selected', style: TextStyle(color: Colors.white54)))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: (selectedTenantData?['profilePic']?.isNotEmpty ?? false)
                  ? NetworkImage(selectedTenantData!['profilePic'])
                  : const AssetImage('assets/avatar.jpg') as ImageProvider,
              radius: 30,
            ),
            const SizedBox(height: 8),
            Text(
              '${selectedTenantData?['name'] ?? ''}\nUnit ${selectedTenantData?['unit'] ?? ''}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            buildInfoRow('Email:', selectedTenantData?['email'] ?? '-'),
            buildInfoRow('Contact Number:', selectedTenantData?['contactNumber'] ?? '-'),
            buildInfoRow('Move-in Date:',
                selectedTenantData?['moveInDate'] is String ? selectedTenantData!['moveInDate'] : '-'),
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
    );
  }
}
