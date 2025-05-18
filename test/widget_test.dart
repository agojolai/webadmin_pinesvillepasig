/*
import 'package:flutter/material.dart';
 

void main() {
  runApp(const TenantManagementApp());
}

class TenantManagementApp extends StatelessWidget {
  const TenantManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const TenantManagementPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TenantManagementPage extends StatelessWidget {
  const TenantManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Tenant Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Invite new tenants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'https://pinesville/invite/link/...',
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Email Address',
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: const Text('Send Link')),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tenants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.pending),
                  label: const Text('Pending application'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by chats and people',
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                    ),
                    title: const Text('Ralph Edwards'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('ralphedwards@gmail.com'),
                        Text('Unit 10${1 + (index % 10)} | Move-in Date: 05/06/2025'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Text('Pinesville Properties', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Tenants'),
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Chats'),
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Bills & Payments'),
          ),
          ListTile(
            leading: Icon(Icons.announcement),
            title: Text('Announcements'),
          ),
          ListTile(
            leading: Icon(Icons.report),
            title: Text('Reports'),
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text('Analytics'),
          ),
        ],
      ),
    );
  }
}
*/