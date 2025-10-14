import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_snackbars.dart';
import 'package:crm/routes/app_routes.dart';
import 'package:crm/services/shred_pref.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

///--------Setup--------
///firebase login
///add sha-1 & sha-256
///
class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;

  final user = Rx<GoogleSignInAccount?>(null);
  final error = Rx<String?>(null);

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

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
      isLoading.value = true;
      error.value = null;

      final googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        user.value = googleUser;
        showlog("user details --> $user");
        // TODO: Send token to your backend or Firebase
        // final googleAuth = await googleUser.authentication;
        // Use googleAuth.accessToken and googleAuth.idToken
        // TODO: add data to user table && update firebase about registered user
        Get.offAllNamed(AppRoutes.dashboard);
      }
    } catch (e) {
      error.value = 'Failed to sign in: ${e.toString()}';
      showlog('Google Sign-In Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      user.value = null;
      Get.offNamed('/login');
    } catch (e) {
      error.value = 'Failed to sign out: ${e.toString()}';
    }
  }

  Future<void> disconnect() async {
    try {
      await _googleSignIn.disconnect();
      user.value = null;
      Get.offNamed('/login');
    } catch (e) {
      error.value = 'Failed to disconnect: ${e.toString()}';
    }
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
