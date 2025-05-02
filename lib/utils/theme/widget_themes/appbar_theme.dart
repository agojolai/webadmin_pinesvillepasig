import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class TAppBarTheme{
  TAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    iconTheme: IconThemeData(color: WebColors.iconPrimary, size: WebSizes.iconMd),
    actionsIconTheme: IconThemeData(color: WebColors.iconPrimary, size: WebSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: WebColors.black, fontFamily: 'Urbanist'),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: WebColors.dark,
    surfaceTintColor: WebColors.dark,
    iconTheme: IconThemeData(color: WebColors.black, size: WebSizes.iconMd),
    actionsIconTheme: IconThemeData(color: WebColors.white, size: WebSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: WebColors.white, fontFamily: 'Urbanist'),
  );
}