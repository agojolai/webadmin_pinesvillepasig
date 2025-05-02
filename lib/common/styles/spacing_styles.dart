import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';

class TSpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: WebSizes.appBarHeight,
    left: WebSizes.defaultSpace,
    bottom: WebSizes.defaultSpace,
    right: WebSizes.defaultSpace,
  );
}
