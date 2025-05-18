import 'package:flutter/material.dart';
import 'announcements_screen.dart';
import 'billspayments_screen.dart';
import 'chat_screen.dart';
import 'login_screen.dart';
import 'reports_screen.dart';
import 'tenants_screen.dart';
import 'units_screen.dart';

import 'dashboard_screen.dart';

class DashboardMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DashboardScreen();
}

class UnitsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) => UnitsScreen();
}

class ChatsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChatsScreen();
}

class BillsPaymentsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BillsPaymentsScreen();
}

class AnnouncementsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AnnouncementsScreen();
}

class ReportsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ReportsScreen();
}

class TenantsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TenantsScreen();
}

class SidebarMenu extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Dashboard', 'icon': 'assets/icons/House_01.png', 'screen': DashboardScreen()},
    {'title': 'Units', 'icon': 'assets/icons/Users_Group.png', 'screen': UnitsScreen()},
    {'title': 'Chats', 'icon': 'assets/icons/Chat_Circle.png', 'screen': ChatsScreen()},
    {'title': 'Bills & Payments', 'icon': 'assets/icons/Credit_Card_02.png', 'screen': BillsPaymentsScreen()},
    {'title': 'Announcements', 'icon': 'assets/icons/User_Voice.png', 'screen': AnnouncementsScreen()},
    {'title': 'Reports', 'icon': 'assets/icons/Octagon_Warning.png', 'screen': ReportsScreen()},
    {'title': 'Analytics', 'icon': 'assets/icons/Chart_Line.png', 'screen': TenantsScreen()},
  ];

  final Map<String, dynamic> logoutItem = {
    'title': 'Log out',
    'icon': 'assets/icons/logout.256x256.png',
    'screen': LoginScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      color: Colors.black87,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Center(
              child: Text(
                'Pinesville Properties',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: menuItems.map((item) {
                return ListTile(
                  leading: Image.asset(
                    item['icon'],
                    width: 24,
                    height: 24,
                    color: Colors.white70,
                  ),
                  title: Text(
                    item['title'],
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => item['screen']),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white70,
              ),
              title: Text(
                logoutItem['title'],
                style: const TextStyle(color: Colors.white70),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => logoutItem['screen']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
