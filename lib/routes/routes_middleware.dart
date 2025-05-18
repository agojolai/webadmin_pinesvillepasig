import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteMiddleware extends GetMiddleware {


RouteSettings? redirect(String? route) {
  print("--------------MIDDLEWARE CALLED---------");
  final isAuthenticated = true;
  return isAuthenticated ? null : const RouteSettings(name: '/login');
  }
}