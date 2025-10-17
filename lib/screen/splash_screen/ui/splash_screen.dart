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
        // Get.offNamed(AppRoutes.dashboard);
        Get.offNamed(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
            Image.asset("assets/images/logo.png", scale: 1.5),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
            const CircularProgressIndicator(),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
          ],
        ),
      ),
    );
  }
}
