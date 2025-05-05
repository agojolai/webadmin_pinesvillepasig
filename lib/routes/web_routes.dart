import 'package:get/get.dart';
import 'package:webadmin_pinesville/data/features.authentication/screens/responsive_screens/login_screen/login.dart';
import 'package:webadmin_pinesville/routes/routes.dart';

class WebAppRoute {
  static final List<GetPage> pages = [
    GetPage(name: WebRoutes.login, page: () => const LoginScreen())
    //GetPage(name: WebRoutes.dashboard, page: () => const DashboardScreen()),
    //GetPage(name: WebRoutes.tenant, page: () => const TenantScreen()),
    //GetPage(name: WebRoutes.chat, page: () => const ChatScreen()),
    //GetPage(name: WebRoutes.billpayment, page: () => const BillPaymentScreen()),
    //GetPage(name: WebRoutes.announcement, page: () => const AnnouncementScreen()),
    //GetPage(name: WebRoutes.report, page: () => const ReportScreen()),
    //GetPage(name: WebRoutes.analytic, page: () => const AnalyticScreen()),
  ];
}