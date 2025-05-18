import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webadmin_pinesville/utils/device/device_utility.dart';
import '../../../../../routes/routes.dart';

class SidebarController extends GetxController {
  final activeItem = Routes.dashboard.obs;
  final hoverItem = ''.obs;

  void changeActiveItem(String route) => activeItem.value = route;

  void changeHoverItem(String route) {
    if (!isActive(route)) hoverItem.value = route;
  }

  bool isActive(String route) => activeItem.value == route;

  bool isHovering(String route) => hoverItem.value == route;

  void menuOnTap(String route) {
    if (isActive(route)) {
      changeActiveItem(route);

      if (DeviceUtils.isMobileScreen(Get.context!)) Get.back();
      Get.toNamed(route);
    }
  }
}
