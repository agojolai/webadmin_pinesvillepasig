import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../repository/auth_repo.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  //variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  void forgetPassword() async {
    try {
      PFullScreenLoader.openLoadingDialog('Processing...');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        PLoaders.errorSnackBar(
            title: 'Error', message: 'Please check your internet connection');
        return;
      }

      if (!forgetPasswordFormKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      }

      await AuthRepository.instance.forgetPassword(email.text.trim());
      PFullScreenLoader.stopLoading();

      //go back to log in screen
      AuthRepository.instance.logout();

      PLoaders.successSnackBar(
          title: 'Success!',
          message: 'Password reset link has been sent to your email.');
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Error', message: e.toString());
      PFullScreenLoader.stopLoading();
    }
  }
}
