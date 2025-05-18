import 'package:flutter/material.dart';
import 'menu.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
                    'Pages / Dashboard',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 0),
                  Text(
                    'Dashboard',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTopCards(),
                  const SizedBox(height: 30),
                  Expanded(child: _buildMiddleAndBottomContent()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCards() {
    final cardData = [
      {'title': 'Total Rent Collected', 'value': '12,045', 'icon': Icons.attach_money},
      {'title': 'Total Rent Remaining', 'value': '12,045', 'icon': Icons.money_off},
      {'title': 'Total Paid Tenants', 'value': '5', 'icon': Icons.check_circle},
      {'title': 'Total Pending Tenants', 'value': '6', 'icon': Icons.pending},
      {'title': 'Tenants', 'value': '16', 'icon': Icons.people},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: cardData.map((data) {
        return _InfoCard(
          title: data['title'] as String,
          value: data['value'] as String,
          icon: data['icon'] as IconData,
        );
      }).toList(),
    );
  }


  Widget _buildMiddleAndBottomContent() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 2, child: _AnnouncementsSection()),
              const SizedBox(width: 16),
              Expanded(child: _PlaceholderCard(title: "Pie Chart")),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _PlaceholderCard(title: "Line Chart")),
              const SizedBox(width: 16),
              Expanded(child: _PlaceholderCard(title: "Bar Chart")),
              const SizedBox(width: 16),
              Expanded(child: _TenantsListCard()),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(height: 200, child: _ReportsSection()),
      ],
    );
  }
}

// Reusable components below

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(color: Colors.orange, fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  final String title;

  const _PlaceholderCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(title, style: const TextStyle(color: Colors.white70)),
      ),
    );
  }
}

class _AnnouncementsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PlaceholderCard(title: "Announcements");
  }
}

class _TenantsListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PlaceholderCard(title: "Tenants");
  }
}

class _ReportsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PlaceholderCard(title: "Tenants Reports");
  }
}
