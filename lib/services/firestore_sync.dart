import 'dart:io';
import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_snackbars.dart';
import 'package:crm/screen/contacts/repo/contact_repo.dart';
import 'package:crm/screen/masters/product/repo/product_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> hasInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } catch (e) {
    return false;
  }
}

Future<void> syncToCloud({required BuildContext context}) async {
  // Check internet connection
  final isConnected = await hasInternetConnection();
  if (!isConnected) {
    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text(
              "No Internet Connection",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Please connect to the internet to sync data.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("OK")),
        ],
      ),
    );
    return;
  }

  if (!context.mounted) return;

  // Show syncing dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const _SyncingDialog(),
  );

  try {
    await ContactsRepo().syncContactsToFirestore();
    await ProductRepo().syncProductsToFirestore();

    if (context.mounted) {
      Get.back(); // Close loading dialog
      showSuccessSnackBar("Data synced successfully.");
    }
  } catch (e) {
    if (context.mounted) {
      Get.back(); // Close loading dialog
      showErrorSnackBar("Data sync failed.");
    }
    AppUtils.showlog("Error syncing data: $e");
  }
}

class _SyncingDialog extends StatelessWidget {
  const _SyncingDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
          SizedBox(height: 16),
          Text(
            "Syncing data...",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
