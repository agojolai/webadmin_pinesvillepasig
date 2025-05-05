import 'package:flutter/material.dart';
import 'package:webadmin_pinesville/data/features.authentication/screens/responsive_screens/login_desktop_tablet.dart';
import 'package:webadmin_pinesville/data/features.authentication/screens/responsive_screens/login_mobile.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreenDesktopTablet();
    //return const WSiteTemplate(useLayout: false, desktop: LoginScreenDesktopTablet(), mobile: LoginScreenMobile());
  }
}