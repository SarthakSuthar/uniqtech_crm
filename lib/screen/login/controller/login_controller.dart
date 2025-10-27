// import 'dart:io';

import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_snackbars.dart';
import 'package:crm/routes/app_routes.dart';
import 'package:crm/screen/login/model/user_model.dart';
import 'package:crm/screen/login/repo/user_repo.dart';
import 'package:crm/services/shred_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

///--------Setup--------
///firebase login
///add sha-1 & sha-256
///
class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;

  final user = Rx<GoogleSignInAccount?>(null);
  final error = Rx<String?>(null);

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: kIsWeb
        ? dotenv.env["GOOGLE_WEB_SIGIN_KEY"]
        : null, // have to update in env according to firebase account
  );

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    if (email == "123@abc.com" && password == "123") {
      await SharedPrefHelper.setBool("isLoggedIn", true);
      showSuccessSnackBar("Logged in successfully!");
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      showErrorSnackBar("Invalid credentials");
    }
    isLoading.value = false;
  }

  Future<void> signInWithGoogle() async {
    try {
      await checkInternet();
      if (internetConnection == true) {
        isLoading.value = true;
        error.value = null;

        if (kIsWeb) {
          await _signInWithGoogleWeb();
        } else {
          await _signInWithGoogleMobile();
        }

        final googleUser = await _googleSignIn.signIn();
        if (googleUser != null) {
          user.value = googleUser;
          AppUtils.showlog("user details --> $user");

          // final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;

          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          await FirebaseAuth.instance.signInWithCredential(credential);

          final userData = UserModel(
            uid: googleUser.id,
            name: googleUser.displayName,
            email: googleUser.email,
            photoUrl: googleUser.photoUrl,
          );
          await UserRepo().insertUser(userData);
          AppUtils.showlog("user data in model --> ${userData.toJson()}");
          await SharedPrefHelper.setBool("isLoggedIn", true);
          await SharedPrefHelper.setBool("firstLogin", true);
          showSuccessSnackBar("Logged in successfully!");
          Get.offAllNamed(AppRoutes.dashboard);
        }
      } else {
        showErrorSnackBar("No Internet Connection!");
      }
    } catch (e) {
      error.value = 'Failed to sign in: ${e.toString()}';
      AppUtils.showlog('Google Sign-In Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _signInWithGoogleMobile() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return; // user canceled

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    final userData = UserModel(
      uid: googleUser.id,
      name: googleUser.displayName,
      email: googleUser.email,
      photoUrl: googleUser.photoUrl,
    );

    await _saveUserAndRedirect(userData);
  }

  Future<void> _signInWithGoogleWeb() async {
    final GoogleAuthProvider authProvider = GoogleAuthProvider();

    final userCredential = await FirebaseAuth.instance.signInWithPopup(
      authProvider,
    );

    final user = userCredential.user;
    if (user == null) return;

    final userData = UserModel(
      uid: user.uid,
      name: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );

    await _saveUserAndRedirect(userData);
  }

  Future<void> _saveUserAndRedirect(UserModel userData) async {
    await UserRepo().insertUser(userData);
    AppUtils.showlog("user data in model --> ${userData.toJson()}");
    await SharedPrefHelper.setBool("isLoggedIn", true);
    await SharedPrefHelper.setBool("firstLogin", true);
    showSuccessSnackBar("Logged in successfully!");
    Get.offAllNamed(AppRoutes.dashboard);
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      user.value = null;
      await UserRepo().deleteUser();
      await SharedPrefHelper.setBool("isLoggedIn", false);
      await SharedPrefHelper.clear();
      Get.offNamed(AppRoutes.login);
    } catch (e) {
      error.value = 'Failed to sign out: ${e.toString()}';
    }
  }

  Future<void> disconnect() async {
    try {
      await _googleSignIn.disconnect();
      user.value = null;
      Get.offNamed(AppRoutes.login);
    } catch (e) {
      error.value = 'Failed to disconnect: ${e.toString()}';
    }
  }

  bool internetConnection = false;

  // Future<void> checkInternet() async {
  //   if (!kIsWeb) {
  //     try {
  //       final result = await InternetAddress.lookup("google.com");
  //       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //         internetConnection = true;
  //       } else {
  //         internetConnection = false;
  //       }
  //     } catch (e) {
  //       AppUtils.showlog("Error checking internet --> $e");
  //       internetConnection = false;
  //     }
  //   }
  // }

  Future<void> checkInternet() async {
    try {
      if (kIsWeb) {
        // Simple online flag for Web
        internetConnection = html.window.navigator.onLine!;
      } else {
        // Lightweight GET check for Mobile
        final response = await http
            .get(Uri.parse('https://www.google.com'))
            .timeout(const Duration(seconds: 3));
        internetConnection = response.statusCode == 200;
      }
    } catch (e) {
      AppUtils.showlog("Error checking internet --> $e");
      internetConnection = false;
    }
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
