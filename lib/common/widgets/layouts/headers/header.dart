import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:webadmin_pinesville/utils/constants/colors.dart';
import 'package:webadmin_pinesville/utils/constants/sizes.dart';
import 'package:webadmin_pinesville/utils/device/device_utility.dart';

class Header extends StatelessWidget implements PreferredSizeWidget{
  const Header({super.key, this.scaffoldKey});

  //GlobalKey to access the scaffold state
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WebColors.primary,
        border: Border(bottom: BorderSide(color: WebColors.primary, width: 1)),
      ),
      padding: EdgeInsets.symmetric(horizontal: WebSizes.md, vertical: WebSizes.sm),
      child: AppBar(
        leading: !DeviceUtils.isDesktopScreen(context) //nagkakaroon lang ng icon kapag tablet mode or mobile
            ? IconButton(onPressed: () => scaffoldKey?.currentState?.openDrawer(), icon: Icon(Iconsax.menu))
            : null,
      ),
    );
  }

//TODO DITO ILALAGAY YUNG IBA IBANG HEADER PER PAGE

  @override
  //TODO IMPLEMENT PREFERRED SIZE WIDGET
  Size get preferredSize => Size.fromHeight(DeviceUtils.getAppBarHeight() + 15);





}
