import 'package:flutter/material.dart';
import 'package:webadmin_pinesville/common/widgets/layouts/templates/site_layout.dart';
import 'package:webadmin_pinesville/features/main/screens.dashboard/responsive_screens/dashboard_desktop.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(desktop: DashboardDesktopScreen());
  }
}
