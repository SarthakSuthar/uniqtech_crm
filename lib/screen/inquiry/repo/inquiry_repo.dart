import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_snackbars.dart';
import 'package:crm/screen/inquiry/model/inquiry_followup_model.dart';
import 'package:crm/screen/inquiry/model/inquiry_model.dart';
import 'package:crm/screen/inquiry/model/inquiry_product_model.dart';
import 'package:crm/services/firestore_sync.dart';
import 'package:crm/services/local_db.dart';
import 'package:sqflite/sqlite_api.dart';

class InquiryRepo {
  static const String table = 'inquiry';
  static const String inquiryProductTable = 'inquiryProduct';
  static const String inquiryFollowupTable = 'inquiryFollowup';

  static Future<void> initializeInquiryDB(Database db) async {
    try {
      await createInquiryTable(db);
      await createinquiryProductTable(db);
      await createInquiryFollowupTable(db);
    } catch (e) {
      AppUtils.showlog("Error initializing Inquiry DB : $e");
    }
  }

  /// Creates the 'inquiry' table in the database if it doesn't already exist.
  static Future<void> createInquiryTable(Database db) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            created_by TEXT,
            updated_by TEXT,
            custId INTEGER,
            cust_name1 TEXT,
            date TEXT,
            email TEXT,
            mobile_no TEXT,
            source TEXT,
            created_at TEXT,
            updated_at TEXT,
            isSynced INTEGER DEFAULT 0
        )
    ''');
  }

  /// Inserts a new inquiry record into the 'inquiry' table.
  static Future<int> insertInquiry(InquiryModel inquiry) async {
    Database db = await DatabaseHelper().database;
    return await db.insert(
      table,
      inquiry.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getNextInquiryId() async {
    Database db = await DatabaseHelper().database;
    final result = await db.rawQuery('SELECT MAX(id) as maxId FROM $table');
    int? maxId = result.first['maxId'] as int?;
    AppUtils.showlog("MAX id = $maxId");
    return (maxId ?? 0) + 1;
  }

  /// Retrieves all inquiry records from the 'inquiry' table.
  static Future<List<InquiryModel>> getAllInquiries() async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(
      table,
      where: 'isSynced != ?',
      whereArgs: [2],
    );
    return result.map((e) => InquiryModel.fromJson(e)).toList();
  }

  /// Retrieves a specific inquiry record by its ID from the 'inquiry' table.
  static Future<InquiryModel> getInquiryById(String id) async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(table, where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return InquiryModel.fromJson(result.first);
    } else {
      throw Exception('Inquiry not found');
    }
  }

  /// Deletes an inquiry record by its ID from the 'inquiry' table.
  static Future<int> deleteInquiry(int id) async {
    Database db = await DatabaseHelper().database;
    // return await db.delete(table, where: 'id = ?', whereArgs: [id]);
    return await db.update(
      table,
      {'isSynced': 2},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Updates an existing inquiry record in the 'inquiry' table.
  static Future<int> updateInquiry(InquiryModel inquiry) async {
    try {
      Database db = await DatabaseHelper().database;
      int changedRows = await db.update(
        table,
        inquiry.toJson(),
        where: 'id = ?',
        whereArgs: [inquiry.id],
      );
      AppUtils.showlog("data updated : $changedRows");
      return changedRows;
    } catch (e) {
      AppUtils.showlog("error on update inquiry : $e");
      rethrow;
    }
  }

  // ----------- Inquiry Product Table -----------
  /// Creates the 'inquiryProduct' table in the database if it doesn't already exist.
  static Future<void> createinquiryProductTable(Database db) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $inquiryProductTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            created_by TEXT,
            updated_by TEXT,
            created_at TEXT,
            updated_at TEXT,
            inquiryId INTEGER,
            productId INTEGER,
            quantity INTEGER,
            remark TEXT,
            isSynced INTEGER DEFAULT 0
        )
    ''');
  }

  /// Inserts a new inquiry product record into the 'inquiryProduct' table.
  static Future<int> insertInquiryProduct(
    InquiryProductModel inquiryProduct,
  ) async {
    Database db = await DatabaseHelper().database;
    return await db.insert(
      inquiryProductTable,
      inquiryProduct.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// Retrieves all inquiry product records from the 'inquiryProduct' table.
  static Future<List<InquiryProductModel>> getAllInquiryProducts() async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(
      inquiryProductTable,
      where: 'isSynced != ?',
      whereArgs: [2],
    );
    return result.map((e) => InquiryProductModel.fromJson(e)).toList();
  }

  /// Retrieves a specific inquiry product record by its ID from the 'inquiryProduct' table.
  static Future<InquiryProductModel> getInquiryProductById(int id) async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(
        inquiryProductTable,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        return InquiryProductModel.fromJson(result.first);
      } else {
        throw Exception('Inquiry product not found');
      }
    } catch (e) {
      AppUtils.showlog("error on get inquiry product by id : $e");
      rethrow;
    }
  }

  /// Updates an existing inquiry product record in the 'inquiryProduct' table.
  static Future<int> updateInquiryProduct(
    InquiryProductModel inquiryProduct,
  ) async {
    try {
      Database db = await DatabaseHelper().database;
      int changedRows = await db.update(
        inquiryProductTable,
        inquiryProduct.toJson(),
        where: 'id = ?',
        whereArgs: [inquiryProduct.id],
      );
      AppUtils.showlog("inquiryProduct updated : $changedRows");
      return changedRows;
    } catch (e) {
      AppUtils.showlog("error on update inquiry product : $e");
      rethrow;
    }
  }

  /// Deletes an inquiry product record by its ID from the 'inquiryProduct' table.
  static Future<int> deleteInquiryProduct(int inquiryId) async {
    Database db = await DatabaseHelper().database;
    // return db.delete(
    //   inquiryProductTable,
    //   where: 'inquiryId = ?',
    //   whereArgs: [inquiryId],
    // );

    return await db.update(
      inquiryProductTable,
      {'isSynced': 2},
      where: 'inquiryId = ?',
      whereArgs: [inquiryId],
    );
  }

  // ---------- Inquiry Follow up Table --------------
  /// Creates the 'inquiryFollowup' table in the database if it doesn't already exist.
  static Future<void> createInquiryFollowupTable(Database db) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $inquiryFollowupTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            inquiryId INTEGER NOT NULL,
            created_by TEXT,
            updated_by TEXT,
            created_at TEXT,
            updated_at TEXT,
            followupDate TEXT,
            followupType TEXT,
            followupStatus TEXT,
            followupRemarks TEXT,
            followupAssignedTo TEXT,
            isSynced INTEGER DEFAULT 0,
            FOREIGN KEY (inquiryId) REFERENCES $table(id) ON DELETE CASCADE
        )
    ''');
  }

  /// Inserts a new inquiry followup record into the 'inquiryFollowup' table.
  static Future<int> insertInquiryFollowup(
    InquiryFollowupModel inquiryFollowup,
  ) async {
    try {
      Database db = await DatabaseHelper().database;
      int changedRows = await db.insert(
        inquiryFollowupTable,
        inquiryFollowup.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      AppUtils.showlog("inquiryFollowup inserted : $changedRows");
      return changedRows;
    } catch (e) {
      AppUtils.showlog("error on insert inquiry followup : $e");
      rethrow;
    }
  }

  ///update inquiry followup record
  static Future<int> updateInquiryFollowup(
    InquiryFollowupModel inquiryFollow,
  ) async {
    try {
      Database db = await DatabaseHelper().database;
      int changedRows = await db.update(
        inquiryFollowupTable,
        inquiryFollow.toUpdateJson(),
        where: 'id = ?',
        whereArgs: [inquiryFollow.id],
      );
      AppUtils.showlog("inquiryFollowup updated : $changedRows");
      return changedRows;
    } catch (e) {
      AppUtils.showlog("error on update inquiry followup : $e");
      rethrow;
    }
  }

  ///get all inquiry followups
  static Future<List<InquiryFollowupModel>> getAllInquiryFollowups() async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(
        inquiryFollowupTable,
        where: 'isSynced != ?',
        whereArgs: [2],
      );
      return result.map((e) => InquiryFollowupModel.fromJson(e)).toList();
    } catch (e) {
      AppUtils.showlog("error on get all inquiry followups : $e");
      return [];
    }
  }

  ///get inquiry follow up by id
  static Future<InquiryFollowupModel> getInquiryFollowupById(int id) async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(
        inquiryFollowupTable,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        return InquiryFollowupModel.fromJson(result.first);
      } else {
        throw Exception('Inquiry followup not found');
      }
    } catch (e) {
      AppUtils.showlog("error on get inquiry followup by id : $e");
      rethrow;
    }
  }

  ///get inquiry followup List by inquiryId
  static Future<List<InquiryFollowupModel>> getInquiryFollowupListByInquiryId(
    int inquiryId,
  ) async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(
        inquiryFollowupTable,
        where: 'inquiryId = ?',
        whereArgs: [inquiryId],
      );

      if (result.isNotEmpty) {
        return result.map((e) => InquiryFollowupModel.fromJson(e)).toList();
      } else {
        throw Exception('Inquiry followup not found');
      }
    } catch (e) {
      AppUtils.showlog("error on get inquiry followup by inquiryId : $e");
      rethrow;
    }
  }

  //delete
  static Future<int> deleteInquiryFollowup(int inquiryId) async {
    try {
      Database db = await DatabaseHelper().database;

      return await db.update(
        inquiryFollowupTable,
        {'isSynced': 2},
        where: 'inquiryId = ?',
        whereArgs: [inquiryId],
      );
    } catch (e) {
      AppUtils.showlog("Error on delete inquiry followup : $e");
      rethrow;
    }
  }

  // -------------------------------------------------------------------------------------------
  // ------------- MARK: upload to firestore
  // -------------------------------------------------------------------------------------------
  final _firestore = FirebaseFirestore.instance;

  Future<void> syncInquiryToFirestore() async {
    try {
      await uploadToFirestore();
      AppUtils.showlog("Inquiry : After uploadToFirestore");

      await downloadFromFirestore();
      AppUtils.showlog("Inquiry : After downloadFromFirestore");
    } catch (e) {
      AppUtils.showlog("Error syncing inquiry to Firestore: $e");
      showErrorSnackBar("Error syncing inquiry to cloud");
    }
  }

  Future<void> uploadToFirestore() async {
    //upload inquiry list
    await uploadInquiryToFirestore();
    //upload product list
    await uploadProductToFirestore();
    //upload followup list
    await uploadFollowupToFirestore();
  }

  static const List<String> followUpFields = [
    'followupDate',
    'followupType',
    'followupStatus',
    'followupRemarks',
    'followupAssignedTo',
  ];

  Future<void> downloadFromFirestore() async {
    await downloadInquiryFromFirestore();
    await downloadProductFromFirestore();
    // await downloadFollowupFromFirestore();
    await FirestoreSyncService().downloadFromFirestore(
      inquiryFollowupTable,
      followUpFields,
    );
  }

  Future<void> uploadInquiryToFirestore() async {
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

  Future<void> uploadProductToFirestore() async {
    final db = await DatabaseHelper().database;

    final newRecords = await db.query(
      inquiryProductTable,
      where: 'isSynced = ?',
      whereArgs: [0],
    );

    for (final record in newRecords) {
      final firestoreData = Map<String, dynamic>.from(record);
      firestoreData['isSynced'] = 1;

      try {
        await _firestore
            .collection(inquiryProductTable)
            .doc(record['id'].toString())
            .set(firestoreData);
      } catch (e) {
        AppUtils.showlog(
          "Failed to sync record ${record['id']} in $inquiryProductTable: $e",
        );
      }
    }

    final deleteRecords = await db.query(
      inquiryProductTable,
      where: 'isSynced = ?',
      whereArgs: [2],
    );

    for (final record in deleteRecords) {
      await _firestore
          .collection(inquiryProductTable)
          .doc(record['id'].toString())
          .delete();
      await db.delete(
        inquiryProductTable,
        where: 'id = ?',
        whereArgs: [record['id']],
      );
    }
  }

  Future<void> uploadFollowupToFirestore() async {
    final db = await DatabaseHelper().database;

    final newRecords = await db.query(
      inquiryFollowupTable,
      where: 'isSynced = ?',
      whereArgs: [0],
    );

    for (final record in newRecords) {
      final firestoreData = Map<String, dynamic>.from(record);
      firestoreData['isSynced'] = 1;

      try {
        await _firestore
            .collection(inquiryFollowupTable)
            .doc(record['id'].toString())
            .set(firestoreData);
      } catch (e) {
        AppUtils.showlog(
          "Failed to sync record ${record['id']} in $inquiryFollowupTable: $e",
        );
      }
    }

    final deleteRecords = await db.query(
      inquiryFollowupTable,
      where: 'isSynced = ?',
      whereArgs: [2],
    );

    for (final record in deleteRecords) {
      await _firestore
          .collection(inquiryFollowupTable)
          .doc(record['id'].toString())
          .delete();
      await db.delete(
        inquiryFollowupTable,
        where: 'id = ?',
        whereArgs: [record['id']],
      );
    }
  }

  Future<void> downloadInquiryFromFirestore() async {
    final db = await DatabaseHelper().database;

    final snapshot = await _firestore.collection(table).get();
    final firestoreDocs = snapshot.docs;

    for (final doc in firestoreDocs) {
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
          'custId': data['custId'],
          'cust_name1': data['cust_name1'],
          'date': data['date'],
          'email': data['email'],
          'mobile_no': data['mobile_no'],
          'source': data['source'],
          'created_at': data['created_at'],
          'updated_at': data['updated_at'],
          'isSynced': 1,
        });
      } else {
        await db.update(
          table,
          {
            'created_by': data['created_by'],
            'updated_by': data['updated_by'],
            'custId': data['custId'],
            'cust_name1': data['cust_name1'],
            'date': data['date'],
            'email': data['email'],
            'mobile_no': data['mobile_no'],
            'source': data['source'],
            'created_at': data['created_at'],
            'updated_at': data['updated_at'],
            'isSynced': 1,
          },
          where: 'id = ?',
          whereArgs: [data['id']],
        );
      }
    }
  }

  Future<void> downloadProductFromFirestore() async {
    final db = await DatabaseHelper().database;

    final snapshot = await _firestore.collection(inquiryProductTable).get();
    final firestoreDocs = snapshot.docs;

    for (final doc in firestoreDocs) {
      final data = doc.data();

      final local = await db.query(
        inquiryProductTable,
        where: 'id = ?',
        whereArgs: [data['id']],
      );

      if (local.isEmpty) {
        await db.insert(inquiryProductTable, {
          'created_by': data['created_by'],
          'updated_by': data['updated_by'],
          'inquiryId': data['inquiryId'],
          'productId': data['productId'],
          'quantity': data['quantity'],
          'remark': data['remark'],
          'created_at': data['created_at'],
          'updated_at': data['updated_at'],
          'isSynced': 1,
        });
      } else {
        await db.update(
          inquiryProductTable,
          {
            'created_by': data['created_by'],
            'updated_by': data['updated_by'],
            'inquiryId': data['inquiryId'],
            'productId': data['productId'],
            'quantity': data['quantity'],
            'remark': data['remark'],
            'created_at': data['created_at'],
            'updated_at': data['updated_at'],
            'isSynced': 1,
          },
          where: 'id = ?',
          whereArgs: [data['id']],
        );
      }
    }
  }

  Future<void> downloadFollowupFromFirestore() async {
    final db = await DatabaseHelper().database;

    final snapshot = await _firestore.collection(inquiryFollowupTable).get();
    final firestoreDocs = snapshot.docs;

    for (final doc in firestoreDocs) {
      final data = doc.data();

      final local = await db.query(
        inquiryFollowupTable,
        where: 'id = ?',
        whereArgs: [data['id']],
      );

      if (local.isEmpty) {
        await db.insert(inquiryFollowupTable, {
          'created_by': data['created_by'],
          'updated_by': data['updated_by'],
          'inquiryId': data['inquiryId'],
          'productId': data['productId'],
          'quantity': data['quantity'],
          'remark': data['remark'],
          'created_at': data['created_at'],
          'updated_at': data['updated_at'],
          'isSynced': 1,
        });
      } else {
        await db.update(
          inquiryFollowupTable,
          {
            'created_by': data['created_by'],
            'updated_by': data['updated_by'],
            'inquiryId': data['inquiryId'],
            'productId': data['productId'],
            'quantity': data['quantity'],
            'remark': data['remark'],
            'created_at': data['created_at'],
            'updated_at': data['updated_at'],
            'isSynced': 1,
          },
          where: 'id = ?',
          whereArgs: [data['id']],
        );
      }
    }
  }
}
