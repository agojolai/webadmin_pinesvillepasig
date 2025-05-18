import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webadmin_pinesville/utils/helpers/network_manager.dart';
import 'data/repository/auth_repo.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'web_app.dart';

/// Entry point of Flutter App
Future<void> main() async {
  // Ensure that widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX Local Storage

  // Remove # sign from url

  // Initialize Firebase & Authentication Repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
    .then((_) => Get.put(AuthRepository()));

  Get.put(NetworkManager());

  // Main App Starts here...
  runApp(PinesvilleLoginApp() as Widget);
}


