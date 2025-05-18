import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'units_screen.dart';

class PinesvilleLoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Rubik',
      ),
      home: UnitsScreen(),
    );
  }
}