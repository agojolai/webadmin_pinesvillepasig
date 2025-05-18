import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import 'sidebar_controller.dart';

class MenuItem extends StatelessWidget {
  const MenuItem(
      {super.key,
      required this.route,
      required this.icon,
      required this.itemName});

  final String route;
  final Image icon;
  final String itemName;

  @override
  Widget build(BuildContext context) {
    final menuController = Get.put(SidebarController());

    return InkWell(
      onTap: () => menuController.menuOnTap(route),
      onHover: (hovering) => hovering
          ? menuController.changeHoverItem(route)
          : menuController.changeHoverItem(''),
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(vertical: WebSizes.xs),
          child: Container(
            decoration: BoxDecoration(
              color: menuController.isHovering(route) ||
                      menuController.isActive(route)
                  ? WebColors.secondary
                  : WebColors.tertiary,
              borderRadius: BorderRadius.circular(WebSizes.cardRadiusMd),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //ICON
                Padding(
                  padding: EdgeInsets.only(
                      left: WebSizes.lg,
                      top: WebSizes.md,
                      bottom: WebSizes.md,
                      right: WebSizes.md),
                  child: SizedBox(
                    width: 24, // Standard icon size
                    height: 24,
                    child: icon,
                  ),
                ),
                // Item Name
                Expanded(
                  child: Text(
                    itemName,
                    style: TextStyle(
                      color: WebColors.white,
                      fontSize: WebSizes.md,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
