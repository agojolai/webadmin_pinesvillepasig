import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Elevated Button Themes -- */
class TElevatedButtonTheme {
  TElevatedButtonTheme._(); //To avoid creating instances


  /* -- Light Theme -- */
  static final lightElevatedButtonTheme  = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: WebColors.light,
      backgroundColor: WebColors.primary,
      disabledForegroundColor: WebColors.darkGrey,
      disabledBackgroundColor: WebColors.buttonDisabled,
      side: const BorderSide(color: WebColors.primary),
      padding: const EdgeInsets.symmetric(vertical: WebSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(WebSizes.buttonRadius)),
      textStyle: const TextStyle(fontSize: 16, color: WebColors.textWhite, fontWeight: FontWeight.w500, fontFamily: 'R'),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: WebColors.light,
      backgroundColor: WebColors.primary,
      disabledForegroundColor: WebColors.darkGrey,
      disabledBackgroundColor: WebColors.darkerGrey,
      side: const BorderSide(color: WebColors.primary),
      padding: const EdgeInsets.symmetric(vertical: WebSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(WebSizes.buttonRadius)),
      textStyle: const TextStyle(fontSize: 16, color: WebColors.textWhite, fontWeight: FontWeight.w600, fontFamily: 'Urbanist'),
    ),
  );
}
