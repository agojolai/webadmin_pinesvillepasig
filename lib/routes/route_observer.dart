import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webadmin_pinesville/routes/routes.dart';

import '../common/widgets/layouts/sidebars/menu/sidebar_controller.dart';

class RouteObservers extends GetObserver {

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final sidebarController = Get.put(SidebarController()); //TODO SAN ILALAGAY SIDEBARCONTROLLER

    if (previousRoute != null) {
      //check the route name and update the active item in the sidebar accordingly
      for (var routeName in Routes.sideBarMenuItems) {
        if (previousRoute.settings.name == routeName) {
          sidebarController.activeItem.value = routeName;
        }
      }
    }
  }

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final sidebarController = Get.put(SidebarController());

    if (route != null) {
      //check the route name and update the active item in the sidebar accordingly
      for (var routeName in Routes.sideBarMenuItems) {
        if (route.settings.name == routeName) {
          sidebarController.activeItem.value = routeName;
        }
      }
    }
  }
}
