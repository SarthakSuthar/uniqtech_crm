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
import 'package:crm/screen/login/service/network_check_stub.dart'
    if (dart.library.html) 'package:crm/screen/login/service/network_check_web.dart'
    if (dart.library.io) 'package:crm/screen/login/service/network_check_mobile.dart';

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

  // Future<void> login(String email, String password) async {
  //   isLoading.value = true;
  //   // Simulate API call
  //   await Future.delayed(const Duration(seconds: 2));
  //   if (email == "123@abc.com" && password == "123") {
  //     await SharedPrefHelper.setBool("isLoggedIn", true);
  //     showSuccessSnackBar("Logged in successfully!");
  //     Get.offAllNamed(AppRoutes.dashboard);
  //   } else {
  //     showErrorSnackBar("Invalid credentials");
  //   }
  //   isLoading.value = false;
  // }

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
        await getUserDetails();
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

  // late bool internetConnection;
  // @override
  // void onInit() async {
  //   super.onInit();
  //   internetConnection = await checkInternet();
  // }

  bool internetConnection = false;

  Future<void> checkInternet() async {
    internetConnection = await checkInternetConnection();
    // internetConnection = await NetworkCheckStub.checkInternet();
    // if (!kIsWeb) {
    //   try {
    //     final result = await InternetAddress.lookup("google.com");
    //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //       internetConnection = true;
    //     } else {
    //       internetConnection = false;
    //     }
    //   } catch (e) {
    //     AppUtils.showlog("Error checking internet --> $e");
    //     internetConnection = false;
    //   }
    // }
  }

  RxString userId = "".obs;
  RxString userName = "".obs;
  RxString userEmail = "".obs;

  Future<void> getUserDetails() async {
    try {
      final result = await UserRepo.getUserData();
      userId.value = result.uid ?? "";
      userName.value = result.name ?? "";
      userEmail.value = result.email ?? "";

      AppUtils.showlog("User id for Drawer --> ${userId.value}");
      AppUtils.showlog("User name for Drawer --> ${userName.value}");
      AppUtils.showlog("User email for Drawer --> ${userEmail.value}");
    } catch (e) {
      AppUtils.showlog("Drawer --> Error getting user details : $e");
    }
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
