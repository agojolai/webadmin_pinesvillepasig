import 'package:get/get.dart';
import 'package:webadmin_pinesville/features/main/screens.dashboard/responsive_screens/dashboard_desktop.dart';
import 'package:webadmin_pinesville/routes/routes.dart';
import 'package:webadmin_pinesville/routes/routes_middleware.dart';

import '../features/authentication/screens/responsive_screens/login_screen/login.dart';

class WebAppRoute {
  static final List<GetPage> pages = [
    GetPage(name: Routes.login, page: () => const LoginScreen(), middlewares: [RouteMiddleware()]),
    GetPage(name: Routes.dashboard, page: () => const DashboardDesktopScreen()),
  //  GetPage(name: Routes.units, page: () => const TenantScreen()),
    //GetPage(name: WebRoutes.chat, page: () => const ChatScreen()),
    //GetPage(name: WebRoutes.billpayment, page: () => const BillPaymentScreen()),
    //GetPage(name: WebRoutes.announcement, page: () => const AnnouncementScreen()),
    //GetPage(name: WebRoutes.report, page: () => const ReportScreen()),
    //GetPage(name: WebRoutes.analytic, page: () => const AnalyticScreen()),
  ];
}