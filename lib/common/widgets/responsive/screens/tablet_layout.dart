import 'package:flutter/material.dart';
import 'package:webadmin_pinesville/common/widgets/layouts/headers/header.dart';
import '../../layouts/sidebars/sidebar.dart';

class TabletLayout extends StatelessWidget {
  TabletLayout({super.key, this.body});

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
