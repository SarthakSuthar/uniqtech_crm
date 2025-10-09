import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSuccessSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    colorText: Colors.white,
    borderRadius: 8,
    margin: const EdgeInsets.all(16),
    icon: const Icon(Icons.check_circle_outline, color: Colors.white),
  );
}

void showErrorSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    borderRadius: 8,
    margin: const EdgeInsets.all(16),
    icon: const Icon(Icons.error_outline, color: Colors.white),
  );
}
