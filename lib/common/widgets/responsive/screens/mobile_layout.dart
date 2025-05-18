import 'package:flutter/material.dart';
import '../../layouts/headers/header.dart';
import '../../layouts/sidebars/sidebar.dart';

class MobileLayout extends StatelessWidget {
   MobileLayout({super.key, this.body});

  final Widget? body;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Sidebar(),
      appBar: Header(scaffoldKey: scaffoldKey),
      body: body ?? SizedBox(),
    );
  }
}
