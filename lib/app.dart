import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webadmin_pinesville/common/widgets/layouts/templates/site_layout.dart';
import 'package:webadmin_pinesville/common/widgets/responsive/responsive_design.dart';
import 'package:webadmin_pinesville/routes/routes.dart';
import 'package:webadmin_pinesville/utils/device/web_material_scroll.dart';
import 'routes/web_routes.dart';
import 'utils/constants/colors.dart';
import 'utils/constants/text_strings.dart';
//import 'utils/device/web_material_scroll.dart';
//import 'utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: DefaultTexts.appName,
      //themeMode: ThemeMode.light,
      theme: ThemeData(
        fontFamily: 'Rubik',
      ),
     // theme: TAppTheme.lightTheme,
    //  darkTheme: TApp5556tTheme.darkTheme,
      getPages: WebAppRoute.pages,
      initialRoute: Routes.login,
      unknownRoute: GetPage(name: '/page-not-found', page: () => const Scaffold(body: Center(child: Text('Page Not Found')))),

      /*

      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      home: const Scaffold(
        backgroundColor: WebColors.primary,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
      */
    );
  }
}

class ResponsiveDesignScreen extends StatelessWidget {
  const ResponsiveDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // pwede tanggalin yung iba, then magiging default ay desktop
    return const SiteTemplate(desktop: Desktop(), tablet: Tablet(), mobile: Mobile());
  }
}
 //TODO NEED LAMANAN NG LAYOUT
class Desktop extends StatelessWidget {
  const Desktop({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class Mobile extends StatelessWidget {
  const Mobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class Tablet extends StatelessWidget {
  const Tablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
