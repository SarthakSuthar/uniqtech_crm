import 'dart:async';
import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/contacts/repo/contact_repo.dart';
import 'package:crm/screen/inquiry/repo/inquiry_repo.dart';
import 'package:crm/screen/masters/product/repo/product_repo.dart';
import 'package:crm/screen/orders/repo/order_repo.dart';
import 'package:crm/screen/quotes/repo/quotation_repo.dart';
import 'package:crm/screen/masters/terms/repo/terms_repo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'CRM_database.db';
  static const _databaseVersion = 1;

  static final DatabaseHelper _databaseHelper = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _databaseHelper;
  }
  Future<Database> get database async {
    // showlog("inside get database");
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database?> _initDatabase() async {
    showlog("inside _initDatabase");
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      showlog("inside _onCreate");
      await db.execute('''
      CREATE TABLE IF NOT EXISTS user (
        uid TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        phone TEXT,
        isSynced INTEGER 
      )
    ''');
      showlog("after creating user table");

      //MARK:  Contact Table
      await ContactsRepo.createTable(db);
      showlog("after creating contact table");

      //MARK: Masters Tables
      await ProductRepo.createTable(db);
      showlog("after creating product table");

      await TermsRepo.createTermsTable(db);
      showlog("after creating terms table");

      //MARK: Inquiry Tables
      // await InquiryRepo.createInquiryTable(db);
      // showlog("after creating inquiry table");

      // await InquiryRepo.createinquiryProductTable(db);
      // showlog("after creating inquiryProduct table");

      // await InquiryRepo.createInquiryFollowupTable(db);
      // showlog("after creating inquiryFollowup table");

      await InquiryRepo.initializeInquiryDB(db);

      //MARK: Quatation Tables
      await QuotationRepo.createQuotationTable(db);
      showlog("after creating quotation table");

      await QuotationRepo.createQuotationProductTable(db);
      showlog("after creating quotationProduct table");

      await QuotationRepo.createQuotationFollowupTable(db);
      showlog("after creating quotationFollowup table");

      await QuotationRepo.createQuotationTermsTable(db);
      showlog("after creating quotationTerms table");

      // SEPERATED AGAIN BECAUSE createQuotationTermsTable ISM'T WORKING IN initializeQuotationDB
      // await QuotationRepo.initializeQuotationDB(db);
      // showlog("after creating quotation tables");

      //MARK: Order Tables
      await OrderRepo.createOrderTable(db);
      showlog("after creating order tables");

      await OrderRepo.createOrderProductTable(db);
      showlog("after creating orderProduct tables");

      await OrderRepo.createOrderTermsTable(db);
      showlog("after creating orderTerms tables");
    } catch (e) {
      // Log the error for debugging or report to an error tracking service
      showlog("Error creating tables: $e");
    }
  }
}
