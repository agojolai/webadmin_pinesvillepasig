import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: WebColors.darkGrey,
    suffixIconColor: WebColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: WebSizes.inputFieldHeight),
 //   labelStyle: const TextStyle().copyWith(fontSize: WebSizes.fontSizeMd, color: WebColors.textPrimary, fontFamily: 'Urbanist'),
   // hintStyle: const TextStyle().copyWith(fontSize: WebSizes.fonWebSizesm, color: WebColors.textSecondary, fontFamily: 'Urbanist'),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal, fontFamily: 'Urbanist'),
    floatingLabelStyle: const TextStyle().copyWith(color: WebColors.textSecondary, fontFamily: 'Urbanist'),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(WebSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: WebColors.borderPrimary),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(WebSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: WebColors.borderPrimary),
    ),
    focusedBorder:const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(WebSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: WebColors.borderSecondary),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(WebSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: WebColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(WebSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: WebColors.error),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: WebColors.darkGrey,
    suffixIconColor: WebColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: WebSizes.inputFieldHeight),
   // labelStyle: const TextStyle().copyWith(fontSize: WebSizes.fontSizeMd, color: WebColors.white, fontFamily: 'Urbanist'),
   // hintStyle: const TextStyle().copyWith(fontSize: WebSizes.fonWebSizesm, color: WebColors.white, fontFamily: 'Urbanist'),
    floatingLabelStyle: const TextStyle().copyWith(color: WebColors.white.withOpacity(0.8), fontFamily: 'Urbanist'),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(WebSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: WebColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(WebSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: WebColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(WebSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: WebColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(WebSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: WebColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(WebSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: WebColors.error),
    ),
  );
}
