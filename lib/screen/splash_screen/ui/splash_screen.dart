import 'dart:async';

import 'package:crm/routes/app_routes.dart';
import 'package:crm/services/shred_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () async {
      bool? isLoggedIn = SharedPrefHelper.getBool("isLoggedIn"); // your logic
      if (isLoggedIn == true) {
        Get.offNamed(AppRoutes.dashboard);
      } else {
        Get.offNamed(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("assets/images/logo.png"),
        const CircularProgressIndicator(),
      ],
    );
  }
}
