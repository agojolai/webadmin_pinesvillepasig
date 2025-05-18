import 'package:flutter/material.dart';
import 'package:webadmin_pinesville/app.dart';
import 'package:webadmin_pinesville/common/widgets/responsive/responsive_design.dart';
import 'package:webadmin_pinesville/common/widgets/responsive/screens/desktop_layout.dart';
import 'package:webadmin_pinesville/common/widgets/responsive/screens/mobile_layout.dart';
import '../../responsive/screens/tablet_layout.dart';


class SiteTemplate extends StatelessWidget {
  const SiteTemplate({super.key,  this.desktop, this.mobile,  this.tablet, this.useLayout = true});


  //widget for desktop layout
  final Widget? desktop;

  //widget for mobile layout
  final Widget?  mobile;

  //widget for tablet layout
  final Widget? tablet;

  final bool useLayout;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveWidget(
          desktop: useLayout ? DesktopLayout(body: desktop) : desktop ?? Container(),
          mobile: useLayout ? MobileLayout(body: mobile ?? desktop): mobile ?? desktop ?? Container() ,
         tablet: useLayout ? TabletLayout(body: tablet ?? desktop): tablet ?? desktop ?? Container(), // ?? desktop if I dont wanna usemobile and tablet
    ),
    );
  }
}
