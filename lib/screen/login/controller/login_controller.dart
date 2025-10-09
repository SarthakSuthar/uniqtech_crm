import 'package:crm/app_const/widgets/app_snackbars.dart';
import 'package:crm/routes/app_routes.dart';
import 'package:crm/services/shred_pref.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    if (email == "123@abc.com" && password == "123") {
      await SharedPrefHelper.setBool("isLoggedIn", true);
      showSuccessSnackBar("Success", "Logged in successfully!");
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      showErrorSnackBar("Login Failed", "Invalid credentials");
    }
    isLoading.value = false;
  }
}
