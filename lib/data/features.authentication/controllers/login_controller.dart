import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:webadmin_pinesville/dashboard_screen.dart';
import 'package:webadmin_pinesville/data/features.authentication/screens/responsive_screens/sidebar_menu.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../repository/auth_repo.dart';

class LoginController extends GetxController {
  //variable
  final hidePassword = true.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  //LOG IN function

  void emailAndPasswordSignIn() async {
    try {
      // Form Validation
      print("back");

      print("tanigna");
      PFullScreenLoader.openLoadingDialog('Processing...');
      print("abagna");
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        PLoaders.errorSnackBar(
            title: 'Error', message: 'Please check your internet connection');
        return;
      }
      print("network");

      // **Form Validation**
      if (!loginFormKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      } // Stop execution if validation fails
      print("local");

      final emailInput = email.text.trim();

      // 🔍 Step 1: Check if the email exists in the approved "Users" collection
      final snapshot = await AuthRepository.instance.firebaseStore
          .collection('admin')
          .where('email', isEqualTo: emailInput)
          .get();
      print("local");
      // If no results, user is not an admin

      // Attempt login - auth repo will verify admin status
      final userCredentials = await AuthRepository.instance
          .logInWithEmailAndPassword(email.text.trim(), password.text.trim());
      print("usercredpassed");

      // If we get here, login was successful
      PFullScreenLoader.stopLoading();
      Get.offAll(() => DashboardScreen());
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
