import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_snackbars.dart';
import 'package:crm/screen/masters/terms/model/terms_model.dart';
import 'package:crm/services/local_db.dart';
import 'package:sqflite/sqflite.dart';

class TermsRepo {
  static const String table = 'terms';

  /// Creates the 'terms' table in the database if it doesn't already exist.
  static Future<void> createTermsTable(Database db) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            isSynced INTEGER DEFAULT 0
        )
    ''');
  }

  /// Inserts a new terms record into the 'terms' table.
  static Future<int> insertTerms(TermsModel terms) async {
    Database db = await DatabaseHelper().database;
    try {
      return await db.insert(
        table,
        terms.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // Handle the error, e.g., log it or rethrow a custom exception
      AppUtils.showlog('inserting terms: $e');
      rethrow;
    }
  }

  /// Retrieves all terms records from the
  static Future<List<TermsModel>> getAllTerms() async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(
        table,
        where: 'isSynced != ?',
        whereArgs: [2],
      );
      AppUtils.showlog('retrieving terms: $result');
      return result.map((e) => TermsModel.fromJson(e)).toList();
    } catch (e) {
      AppUtils.showlog('retrieving terms: $e');
      rethrow;
    }
  }

  ///delete term
  static Future<int> deleteTerm(int id) async {
    Database db = await DatabaseHelper().database;
    try {
      // await db.delete(table, where: 'id = ?', whereArgs: [id]);

      return await db.update(
        table,
        {'isSynced': 2},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      AppUtils.showlog('deleting terms: $e');
      rethrow;
    }
  }

  // -------------------------------------------------------------------------
  // --------------  MARK: upload to firestore
  //--------------------------------------------------------------------------

  final _firestore = FirebaseFirestore.instance;

  Future<void> syncTermsToFirestore() async {
    try {
      await uploadToFirestore();
      AppUtils.showlog("TERMS : After uploadToFirestore");

      await downloadFromFirestore();
      AppUtils.showlog("TERMS : After downloadFromFirestore");
    } catch (e) {
      AppUtils.showlog("Error syncing TERMS to Firestore: $e");
      showErrorSnackBar("Error syncing TERMS to cloud");
    }
  }

  Future<void> uploadToFirestore() async {
    final db = await DatabaseHelper().database;

    //  Upload new (isSynced = 0)
    final newRecords = await db.query(
      table,
      where: 'isSynced = ?',
      whereArgs: [0],
    );

    for (final record in newRecords) {
      // Prepare Firestore data but override isSynced to 1 for cloud
      final firestoreData = Map<String, dynamic>.from(record);
      firestoreData['isSynced'] = 1;

      try {
        // Upload to Firestore
        await _firestore
            .collection(table)
            .doc(record['id'].toString())
            .set(firestoreData);
      } catch (e) {
        AppUtils.showlog("Failed to sync record ${record['id']} in $table: $e");
      }
    }

    //  Delete records from Firestore (isSynced = 2)
    final deletedRecords = await db.query(
      table,
      where: 'isSynced = ?',
      whereArgs: [2],
    );

    for (final record in deletedRecords) {
      await _firestore.collection(table).doc(record['id'].toString()).delete();
      await db.delete(table, where: 'id = ?', whereArgs: [record['id']]);
    }
  }

  Future<void> downloadFromFirestore() async {
    final db = await DatabaseHelper().database;

    final snapshot = await _firestore.collection(table).get();
    final firestoreDocs = snapshot.docs;

    for (final doc in firestoreDocs) {
      final data = doc.data();

      // Check if exists locally
      final local = await db.query(
        table,
        where: 'id = ?',
        whereArgs: [data['id']],
      );

      if (local.isEmpty) {
        await db.insert(table, {
          'title': data['title'],
          'description': data['description'],
          'isSynced': 1,
        });
      } else {
        // Update local record if Firestore version is newer
        await db.update(
          table,
          {
            'title': data['title'],
            'description': data['description'],
            'isSynced': 1,
          },
          where: 'id = ?',
          whereArgs: [data['id']],
        );
      }
    }
  }
}
