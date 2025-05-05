import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  final List<Map<String, String>> menuItems = [
    {'title': 'Dashboard', 'icon': 'assets/icon_assets/House_01.png'},
    {'title': 'Tenants', 'icon': 'assets/icon_assets/Users_Group.png'},
    {'title': 'Chats', 'icon': 'assets/icon_assets/Chat_Circle.png'},
    {'title': 'Bills & Payments', 'icon': 'assets/icon_assets/Credit_Card_02.png'},
    {'title': 'Announcements', 'icon': 'assets/icon_assets/User_Voice.png'},
    {'title': 'Reports', 'icon': 'assets/icon_assets/Octagon_Warning.png'},
    {'title': 'Analytics', 'icon': 'assets/icon_assets/Chart_Line.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      color: Colors.black87,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
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
                    item['icon']!,
                    width: 24,
                    height: 24,
                    color: Colors.white70,
                  ),
                  title: Text(
                    item['title']!,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () {},
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}