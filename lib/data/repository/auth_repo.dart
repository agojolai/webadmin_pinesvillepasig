import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:webadmin_pinesville/dashboard_screen.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../login_screen.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  //variables
  final _auth = FirebaseAuth.instance;
  final firebaseStore = FirebaseFirestore.instance;

  //get authenticated user data
  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  Future<void> screenRedirect() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Check if user is admin
        final adminDoc = await firebaseStore
            .collection('admin')
            .where('Email', isEqualTo: user.email)
            .get();

        if (adminDoc.docs.isEmpty) {
          // Try lowercase
          final lowerAdminDoc = await firebaseStore
              .collection('admin')
              .where('email', isEqualTo: user.email)
              .get();

          if (lowerAdminDoc.docs.isEmpty) {
            await _auth.signOut();
            Get.offAll(() => LoginScreen());
            return;
          }
        }
        Get.offAll(() => DashboardScreen());
      } else {
        Get.offAll(() => LoginScreen());
      }
    } catch (e) {
      Get.offAll(() => LoginScreen());
    }
  }

  /*-----------------------Email and Password Sign In------------------------*/

  //Email auth LogIN
  Future<UserCredential> logInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Attempt login first
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      throw PFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Email auth SignUp
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw PFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Forget Password
  Future<void> forgetPassword(String email) async {
    try {
      // Check if email exists in admin collection
      final adminDoc = await firebaseStore
          .collection('admin')
          .where('Email', isEqualTo: email)
          .get();

      if (adminDoc.docs.isEmpty) {
        // Try lowercase
        final lowerAdminDoc = await firebaseStore
            .collection('admin')
            .where('email', isEqualTo: email)
            .get();

        if (lowerAdminDoc.docs.isEmpty) {
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'This email is not authorized for admin access.',
          );
        }
      }

      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw PFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //log out
  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAll(() => LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw PFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
