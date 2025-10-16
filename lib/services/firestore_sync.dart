import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_snackbars.dart';
import 'package:crm/screen/contacts/repo/contact_repo.dart';
import 'package:crm/screen/inquiry/repo/inquiry_repo.dart';
import 'package:crm/screen/masters/product/repo/product_repo.dart';
import 'package:crm/screen/masters/terms/repo/terms_repo.dart';
import 'package:crm/screen/masters/uom/repo/uom_repo.dart';
import 'package:crm/screen/quotes/repo/quotation_repo.dart';
import 'package:crm/services/local_db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqlite_api.dart';

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
    //MARK: Masters
    await ProductRepo().syncProductsToFirestore();
    await TermsRepo().syncTermsToFirestore();
    await UomRepo().syncUOMToFirestore();

    //MARK: Contacts
    await ContactsRepo().syncContactsToFirestore();

    //MARK: Inquiry
    await InquiryRepo().syncInquiryToFirestore();

    //MARK: Quotation
    await QuotationRepo().syncQuotationToFirestore();

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

class FirestoreSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generic method to sync any table with Firestore
  Future<void> uploadTableToFirestore(String table) async {
    final db = await DatabaseHelper().database;

    try {
      // Upload new records (isSynced = 0)
      final newRecords = await db.query(
        table,
        where: 'isSynced = ?',
        whereArgs: [0],
      );

      for (final record in newRecords) {
        final firestoreData = Map<String, dynamic>.from(record);
        firestoreData['isSynced'] = 1; // Store as synced in Firestore

        try {
          await _firestore
              .collection(table)
              .doc(record['id'].toString())
              .set(firestoreData);
        } catch (e) {
          AppUtils.showlog(
            "❌ Failed to upload record ${record['id']} in $table: $e",
          );
        }
      }

      // Delete records (isSynced = 2)
      final deleteRecords = await db.query(
        table,
        where: 'isSynced = ?',
        whereArgs: [2],
      );

      for (final record in deleteRecords) {
        try {
          await _firestore
              .collection(table)
              .doc(record['id'].toString())
              .delete();

          // Also remove from local DB
          await db.delete(table, where: 'id = ?', whereArgs: [record['id']]);
        } catch (e) {
          AppUtils.showlog(
            "❌ Failed to delete record ${record['id']} in $table: $e",
          );
        }
      }

      AppUtils.showlog("Sync completed for table: $table");
    } catch (e) {
      AppUtils.showlog("Error syncing table $table: $e");
    }
  }

  Future<void> downloadFromFirestore(String table, List<String> fields) async {
    final db = await DatabaseHelper().database;

    final snapshot = await _firestore.collection(table).get();
    final firestoreDocs = snapshot.docs;

    for (var doc in firestoreDocs) {
      final data = doc.data();

      final local = await db.query(
        table,
        where: 'id = ?',
        whereArgs: [data['id']],
      );

      if (local.isEmpty) {
        await db.insert(table, {
          'created_by': data['created_by'],
          'updated_by': data['updated_by'],
          'created_at': data['created_at'],
          'updated_at': data['updated_at'],
          for (var field in fields) field: data[field],
          'isSynced': 1,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      } else {
        await db.update(
          table,
          {for (var field in fields) field: data[field], 'isSynced': 1},
          where: 'id = ?',
          whereArgs: [data['id']],
        );
      }
    }
  }
}
