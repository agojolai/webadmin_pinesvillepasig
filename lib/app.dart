import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webadmin_pinesville/utils/device/web_material_scroll.dart';
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
      themeMode: ThemeMode.light,
     // theme: TAppTheme.lightTheme,
    //  darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      home: const Scaffold(
        backgroundColor: WebColors.primary,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }
}
