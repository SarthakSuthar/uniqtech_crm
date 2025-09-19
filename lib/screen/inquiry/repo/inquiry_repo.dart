import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/inquiry/model/inquiry_followup_model.dart';
import 'package:crm/screen/inquiry/model/inquiry_model.dart';
import 'package:crm/screen/inquiry/model/inquiry_product_model.dart';
import 'package:crm/services/local_db.dart';
import 'package:sqflite/sqlite_api.dart';

class InquiryRepo {
  static const String table = 'inquiry';
  static const String inquiryProductTable = 'inquiryProduct';
  static const String inquiryFollowupTable = 'inquiryFollowup';

  /// Creates the 'inquiry' table in the database if it doesn't already exist.
  static Future<void> createInquiryTable(Database db) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uid TEXT UNIQUE,
            custId INTEGER,
            cust_name1 TEXT,
            cust_name2 TEXT,
            date TEXT,
            email TEXT,
            mobile_no TEXT,
            source TEXT,
            isSynced INTEGER
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

  /// Retrieves all inquiry records from the 'inquiry' table.
  static Future<List<InquiryModel>> getAllInquiries() async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(table);
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
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateInquiry(InquiryModel inquiry) async {
    try {
      Database db = await DatabaseHelper().database;
      int changedRows = await db.update(
        table,
        inquiry.toJson(),
        where: 'id = ?',
        whereArgs: [inquiry.id],
      );
      showlog("data updated : $changedRows");
      return changedRows;
    } catch (e) {
      showlog("error on update inquiry : $e");
      rethrow;
    }
  }

  // ----------- Inquiry Product Table -----------
  /// Creates the 'inquiryProduct' table in the database if it doesn't already exist.
  static Future<void> createinquiryProductTable(Database db) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $inquiryProductTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            inquiryId INTEGER,
            productId INTEGER,
            quentity INTEGER,
            isSynced INTEGER
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
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieves all inquiry product records from the 'inquiryProduct' table.
  static Future<List<InquiryProductModel>> getAllInquiryProducts() async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(inquiryProductTable);
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
      showlog("error on get inquiry product by id : $e");
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
      showlog("inquiryProduct updated : $changedRows");
      return changedRows;
    } catch (e) {
      showlog("error on update inquiry product : $e");
      rethrow;
    }
  }

  /// Deletes an inquiry product record by its ID from the 'inquiryProduct' table.
  static Future<int> deleteInquiryProduct(int inquiryId) async {
    Database db = await DatabaseHelper().database;
    return db.delete(
      inquiryProductTable,
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
            inquiryId INTEGER,
            followupDate TEXT,
            followupStatus TEXT,
            followupRemarks TEXT,
            followupAssignedTo TEXT,
            isSynced INTEGER
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
      showlog("inquiryFollowup inserted : $changedRows");
      return changedRows;
    } catch (e) {
      showlog("error on insert inquiry followup : $e");
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
        inquiryFollow.toJson(),
        where: 'id = ?',
        whereArgs: [inquiryFollow.id],
      );
      showlog("inquiryFollowup updated : $changedRows");
      return changedRows;
    } catch (e) {
      showlog("error on update inquiry followup : $e");
      rethrow;
    }
  }

  ///get all inquiry followups
  static Future<List<InquiryFollowupModel>> getAllInquiryFollowups() async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(inquiryFollowupTable);
      return result.map((e) => InquiryFollowupModel.fromJson(e)).toList();
    } catch (e) {
      showlog("error on get all inquiry followups : $e");
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
      showlog("error on get inquiry followup by id : $e");
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
      showlog("error on get inquiry followup by inquiryId : $e");
      rethrow;
    }
  }
}
