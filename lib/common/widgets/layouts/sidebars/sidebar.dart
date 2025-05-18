import 'package:flutter/material.dart';
import 'package:webadmin_pinesville/utils/constants/colors.dart';
import 'package:webadmin_pinesville/utils/constants/sizes.dart';

import 'menu/menu_item.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: BoxDecoration(
            color: WebColors.secondary,
            border: Border(right: BorderSide(color: WebColors.grey, width: 1))
            //LAGYAN PA BA NG BORDER?
            ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(WebSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Pinesville Properties',
                        style: TextStyle(
                          fontSize: 19,
                          //fontFamily: Rubi, TODO HOW TO CALL FONT
                          color: WebColors.white,
                        )),
                    const SizedBox(height: WebSizes.spaceBtwItems),

                    // Menu Items
                    MenuItem(
                        route: '/dashboard',
                        icon: Image.asset(
                          'assets/icons/House_01.png',
                          color: WebColors.white,
                        ),
                        itemName: 'Dashboard'),
                    const SizedBox(height: WebSizes.spaceBtwItems),

                    MenuItem(
                        route: '/units',
                        icon: Image.asset(
                          'assets/icons/Users_Group.png',
                          color: WebColors.white,
                        ),
                        itemName: 'Units'),
                    const SizedBox(height: WebSizes.spaceBtwItems),

                    MenuItem(
                        route: '/chats',
                        icon: Image.asset(
                          'assets/icons/Chat_Circle.png',
                          color: WebColors.white,
                        ),
                        itemName: 'Chats'),
                    const SizedBox(height: WebSizes.spaceBtwItems),

                    MenuItem(
                        route: '/bills-payments',
                        icon: Image.asset(
                          'assets/icons/Credit_Card_02.png',
                          color: WebColors.white,
                        ),
                        itemName: 'Bills & Payments'),
                    const SizedBox(height: WebSizes.spaceBtwItems),

                    MenuItem(
                        route: '/announcements',
                        icon: Image.asset(
                          'assets/icons/User_Voice.png',
                          color: WebColors.white,
                        ),
                        itemName: 'Announcements'),
                    const SizedBox(height: WebSizes.spaceBtwItems),

                    MenuItem(
                        route: '/reports',
                        icon: Image.asset(
                          'assets/icons/Octagon_Warning.png',
                          color: WebColors.white,
                        ),
                        itemName: 'Reports'),
                    const SizedBox(height: WebSizes.spaceBtwItems),

                    MenuItem(
                        route: '/analytics',
                        icon: Image.asset(
                          'assets/icons/Chart_Line.png',
                          color: WebColors.white,
                        ),
                        itemName: 'Analytics'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
