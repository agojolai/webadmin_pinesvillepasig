 import 'package:flutter/material.dart';
import 'package:webadmin_pinesville/common/widgets/layouts/headers/header.dart';
import '../../layouts/sidebars/sidebar.dart';

class DesktopLayout extends StatelessWidget {
  DesktopLayout({super.key, this.body});

  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
      children: [
        Expanded(child: Sidebar()),
        Expanded(
        flex: 5, //takes only 5x of space??
        child: Column(
          children: [
            //header TODO ANO YUNG HEADER
            Header(),
          
            //body
            Expanded(child: body ?? SizedBox())
          ],
        ),
        )
      ],)
    );
  }
}
