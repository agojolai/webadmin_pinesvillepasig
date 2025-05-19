import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> showComposeAnnouncementDialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  String? selectedRecipient;

  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 600,
          child: Form(
            key: _formKey,
            child: StatefulBuilder(
              builder: (context, setState) {
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('Users').get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent));
                    }

                    if (snapshot.hasError) {
                      return const Text('Error loading tenants', style: TextStyle(color: Colors.redAccent));
                    }

                    // Build recipients list
                    final recipients = ['Everyone'];
                    final docs = snapshot.data!.docs;
                    for (var doc in docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      final firstName = data['FirstName'];
                      final lastName = data['LastName'];

                      if (firstName != null && lastName != null) {
                        final fullName = '$firstName $lastName';
                        recipients.add(fullName);
                      }
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'New Announcement',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Dropdown: To
                        DropdownButtonFormField<String>(
                          value: selectedRecipient,
                          dropdownColor: const Color(0xFF2A2A2A),
                          decoration: _inputDecoration("To"),
                          iconEnabledColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          items: recipients.map((recipient) {
                            return DropdownMenuItem<String>(
                              value: recipient,
                              child: Text(recipient),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => selectedRecipient = value);
                          },
                          validator: (value) => value == null ? 'Please select a recipient' : null,
                        ),
                        const SizedBox(height: 16),

                        _buildInput('Subject', subjectController),
                        const SizedBox(height: 16),

                        _buildInput('Start your message...', messageController, maxLines: 6),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey[400],
                              ),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2A2A2A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await FirebaseFirestore.instance.collection('announcements').add({
                                    'recipient': selectedRecipient,
                                    'title': subjectController.text.trim(),
                                    'message': messageController.text.trim(),
                                    'timestamp': FieldValue.serverTimestamp(),
                                  });
                                  Navigator.of(context).pop();
                                }
                              },
                              icon: const Icon(Icons.send, color: Colors.orangeAccent),
                              label: const Text(
                                'Publish',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildInput(String hint, TextEditingController controller, {int maxLines = 1}) {
  return TextFormField(
    controller: controller,
    style: const TextStyle(color: Colors.white),
    maxLines: maxLines,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter $hint';
      }
      return null;
    },
    decoration: _inputDecoration(hint),
  );
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.grey),
    filled: true,
    fillColor: const Color(0xFF2A2A2A),
    border: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.orangeAccent),
    ),
    errorStyle: const TextStyle(color: Colors.redAccent),
  );
}
