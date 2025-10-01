import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/quotes/model/quotation_followup_model.dart';
import 'package:crm/screen/quotes/model/quotation_model.dart';
import 'package:crm/screen/quotes/model/quotation_product_model.dart';
import 'package:crm/screen/quotes/model/quotation_terms_model.dart';
import 'package:crm/services/local_db.dart';
import 'package:sqflite/sqlite_api.dart';

class QuotationRepo {
  static const String quotationTable = 'quotation';
  static const String quotationProductTable = 'quotationProduct';
  static const String quotationFollowupTable = 'quotationFollowup';
  static const String quotationTermsTable = 'quotationTerms';

  static Future<void> initializeQuotationDB(Database db) async {
    try {
      // Database db = await DatabaseHelper().database;
      await createQuotationTable(db);
      await createQuotationProductTable(db);
      await createQuotationFollowupTable(db);
      await createQuotationTermsTable(db);
    } catch (e) {
      showlog("Error initializing Quotation DB : $e");
    }
  }

  // --------- quotation table -----

  /// Creates the 'quotation' table in the database if it doesn't already exist.
  static Future<void> createQuotationTable(Database db) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $quotationTable (
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

    showlog("Create Quotation Table");
  }

  ///insert a new quotation record into the "quotation" table
  static Future<int> insertQuotation(QuotationModel quotation) async {
    Database db = await DatabaseHelper().database;
    return await db.insert(
      quotationTable,
      quotation.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  ///get all quotations from the "quotation" table
  static Future<List<QuotationModel>> getAllQuotations() async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(quotationTable);
    return result.map((e) => QuotationModel.fromJson(e)).toList();
  }

  ///get quotation by id from the "quotation" table
  static Future<QuotationModel> getQuotationById(String id) async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(
      quotationTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return QuotationModel.fromJson(result.first);
    } else {
      throw Exception('Quotation not found');
    }
  }

  ///delete a quotation record from the "quotation" table
  static Future<int> deleteQuotation(int id) async {
    Database db = await DatabaseHelper().database;
    return await db.delete(quotationTable, where: 'id = ?', whereArgs: [id]);
  }

  ///update an existing quotation record in the 'quotation' table
  static Future<int> updateQuotation(QuotationModel quotation) async {
    try {
      Database db = await DatabaseHelper().database;
      int changedRows = await db.update(
        quotationTable,
        quotation.toJson(),
        where: 'id = ?',
        whereArgs: [quotation.id],
      );
      return changedRows;
    } catch (e) {
      rethrow;
    }
  }

  // --------- quotation product table -----

  ///Create the 'quotationProduct' table in the database if it dosen't already exist.
  static Future<void> createQuotationProductTable(Database db) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $quotationProductTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            quotationId INTEGER,
            productId INTEGER,
            quentity INTEGER,
            isSynced INTEGER
        )
    ''');

    showlog("Create Quotation Product Table");
  }

  ///Insert a new quotation product record into the 'quotationProduct' table
  static Future<int> insertQuotationProduct(
    QuotationProductModel quotationProduct,
  ) async {
    Database db = await DatabaseHelper().database;
    return await db.insert(
      quotationProductTable,
      quotationProduct.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// retrive all quotation product
  static Future<List<QuotationProductModel>> getAllQuotationProducts() async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(quotationProductTable);
    return result.map((e) => QuotationProductModel.fromJson(e)).toList();
  }

  ///retrives a specific quotation product record by id
  static Future<QuotationProductModel> getQuotationProductById(int id) async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(
        quotationProductTable,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        return QuotationProductModel.fromJson(result.first);
      } else {
        throw Exception('Quotation product not found');
      }
    } catch (e) {
      showlog("Error on get quotation product by id : $e");
      rethrow;
    }
  }

  ///Updates an existing qotation record in the 'qotation table.
  static Future<int> updateQuotationProduct(
    QuotationProductModel quotationProduct,
  ) async {
    try {
      Database db = await DatabaseHelper().database;
      int changedRows = await db.update(
        quotationProductTable,
        quotationProduct.toJson(),
        where: 'id = ?',
        whereArgs: [quotationProduct.id],
      );
      showlog("quotationProduct updated : $changedRows");
      return changedRows;
    } catch (e) {
      showlog("error on update quotation product : $e");
      rethrow;
    }
  }

  ///Deletes an quotationrecord by its ID from the 'quotationtable.
  static Future<int> deleteQuotationProduct(int quotationId) async {
    Database db = await DatabaseHelper().database;
    return db.delete(
      quotationProductTable,
      where: 'quotationId = ?',
      whereArgs: [quotationId],
    );
  }

  // --------- quotation followup table -----

  ///Creates the 'quotation table in the database if it doesn't already exist.
  static Future<void> createQuotationFollowupTable(Database db) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $quotationFollowupTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            quotationId INTEGER NOT NULL,
            followupDate TEXT,
            followupType TEXT,
            followupStatus TEXT,
            followupRemarks TEXT,
            followupAssignedTo TEXT,
            isSynced INTEGER,
            FOREIGN KEY (quotationId) REFERENCES $quotationTable(id) ON DELETE CASCADE
        )
    ''');

    showlog("Create Quotation Followup Table");
  }

  /// Inserts a new quotation record into the 'quotation table.
  static Future<int> insertQuotationFollowup(
    QuotationFollowupModel quotationFollowup,
  ) async {
    try {
      Database db = await DatabaseHelper().database;
      int changedRows = await db.insert(
        quotationFollowupTable,
        quotationFollowup.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      showlog("quotationFollowup inserted : $changedRows");
      return changedRows;
    } catch (e) {
      showlog("Error on insert quotation followup : $e");
      rethrow;
    }
  }

  ///update quotation record
  static Future<int> updateQuotationFollowup(
    QuotationFollowupModel quotationFollow,
  ) async {
    try {
      Database db = await DatabaseHelper().database;
      int changedRows = await db.update(
        quotationFollowupTable,
        quotationFollow.toUpdateJson(),
        where: 'id = ?',
        whereArgs: [quotationFollow.id],
      );
      showlog("quotationFollowup updated : $changedRows");
      return changedRows;
    } catch (e) {
      showlog("Error on update quotation followup : $e");
      rethrow;
    }
  }

  ///get all quotation followup
  static Future<List<QuotationFollowupModel>> getAllQuotationFollowups() async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(quotationFollowupTable);
      return result.map((e) => QuotationFollowupModel.fromJson(e)).toList();
    } catch (e) {
      showlog("Error on get all quotation followups : $e");
      return [];
    }
  }

  ///get quotation followup by id
  static Future<QuotationFollowupModel> getQuotationFollowupById(int id) async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(
        quotationFollowupTable,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        return QuotationFollowupModel.fromJson(result.first);
      } else {
        throw Exception('Quotation followup not found');
      }
    } catch (e) {
      showlog("error on get quotation followup by id : $e");
      rethrow;
    }
  }

  ///get quotation followup list by quoyationId
  static Future<List<QuotationFollowupModel>>
  getQuotationFollowupListByQuotationId(int quotationId) async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(
        quotationFollowupTable,
        where: 'quotationId = ?',
        whereArgs: [quotationId],
      );
      if (result.isNotEmpty) {
        return result.map((e) => QuotationFollowupModel.fromJson(e)).toList();
      } else {
        throw Exception('Quotation followup not found');
      }
    } catch (e) {
      showlog("error on get quotation followup by quotationId : $e");
      rethrow;
    }
  }

  // ------- Quotation terms ---------

  //table

  //create table
  static Future<void> createQuotationTermsTable(Database db) async {
    try {
      await db.execute('''
    CREATE TABLE IF NOT EXISTS $quotationTermsTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          quotationId INTEGER,
          termId INTEGER,
          isSynced INTEGER
      )
  ''');

      showlog("Create Quotation Terms Table");
    } catch (e) {
      showlog("Error creating Quotation Terms Table: $e");
    }
  }

  //insert
  static Future<int> insertQuotationTerms(
    QuotationTermsModel quotationTermsModel,
  ) async {
    Database db = await DatabaseHelper().database;
    return await db.insert(
      quotationTermsTable,
      quotationTermsModel.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //get delected term id and return
  static Future<int> getDeletedTerms(int quotationId) async {
    Database db = await DatabaseHelper().database;
    final result = await db.delete(
      quotationTermsTable,
      where: 'quotationId = ?',
      whereArgs: [quotationId],
    );
    return result;
  }

  //get selected term id and return
  static Future<List<QuotationTermsModel>> getSelectedTerms(
    int quotationId,
  ) async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(
      quotationTermsTable,
      where: 'quotationId = ?',
      whereArgs: [quotationId],
    );
    return result.map((e) => QuotationTermsModel.fromJson(e)).toList();
  }
}
