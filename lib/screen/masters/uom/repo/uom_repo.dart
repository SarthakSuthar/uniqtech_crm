import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_snackbars.dart';
import 'package:crm/screen/masters/uom/model/uom_model.dart';
import 'package:crm/services/local_db.dart';
import 'package:sqflite/sqlite_api.dart';

class UomRepo {
  static const String table = 'uom';

  /// Creates the 'uom' table in the database if it doesn't already exist.
  static Future<void> createUomTable(Database db) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $table (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE,
          code TEXT UNIQUE,
          isSynced INTEGER DEFAULT 0
        );
    ''');
  }

  ///insert a new record
  static Future<int> insertUom(UomModel uom) async {
    Database db = await DatabaseHelper().database;
    try {
      return await db.insert(
        table,
        uom.toJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      AppUtils.showlog('Error inserting uom: $e');
      rethrow;
    }
  }

  ///retrive all uom
  static Future<List<UomModel>> getAllUom() async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(
        table,
        where: 'isSynced != ?',
        whereArgs: [2],
      );
      return result.map((e) => UomModel.fromJson(e)).toList();
    } catch (e) {
      AppUtils.showlog('retrieving uom: $e');
      rethrow;
    }
  }

  ///delete uom
  static Future<int> deleteUom(int id) async {
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
      AppUtils.showlog('deleting uom: $e');
      rethrow;
    }
  }

  // -------------------------------------------------------------------------
  // --------------  MARK: upload to firestore
  //--------------------------------------------------------------------------

  final _firestore = FirebaseFirestore.instance;

  Future<void> syncUOMToFirestore() async {
    try {
      await uploadToFirestore();
      AppUtils.showlog("UOM : After uploadToFirestore");

      await downloadFromFirestore();
      AppUtils.showlog("UOM : After downloadFromFirestore");
    } catch (e) {
      AppUtils.showlog("Error syncing UOM to Firestore: $e");
      showErrorSnackBar("Error syncing UOM to cloud");
    }
  }

  Future<void> uploadToFirestore() async {
    final db = await DatabaseHelper().database;

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
          'name': data['name'],
          'code': data['code'],
          'isSynced': 1,
        });
      } else {
        await db.update(
          table,
          {'name': data['name'], 'code': data['code'], 'isSynced': 1},
          where: 'id = ?',
          whereArgs: [data['id']],
        );
      }
    }
  }
}
