import 'package:flutter/material.dart';
import 'package:webadmin_pinesville/utils/constants/sizes.dart';


class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({super.key,  required this.desktop,required this.mobile, required this.tablet});

  //widget for desktop layout
  final Widget desktop;

  //widget for mobile layout
  final Widget  mobile;

  //widget for tablet layout
  final Widget tablet;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder:(_, constraints) {
          if (constraints.maxWidth >= WebSizes.desktopScreenSize) {
            return desktop;
          } else if (constraints.maxWidth < WebSizes.desktopScreenSize && constraints.maxWidth >= WebSizes.tabletScreenSize) {
            return tablet;
          } else {
            return mobile;
          }
    }
    );
  }
}
