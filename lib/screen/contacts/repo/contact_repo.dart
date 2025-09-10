import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/contacts/model/contact_model.dart';
import 'package:crm/services/local_db.dart';
import 'package:sqflite/sqlite_api.dart';

class ContactsRepo {
  static const String table = 'contact';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uid TEXT UNIQUE,
        cust_name TEXT,
        address TEXT,
        city TEXT,
        state TEXT,
        district TEXT,
        country TEXT,
        pincode TEXT,
        mobile_no TEXT,
        email TEXT,
        website TEXT,
        business_type TEXT,
        industry_type TEXT,
        status TEXT,
        contact_name TEXT,
        department TEXT,
        designation TEXT,
        cont_email TEXT,
        cont_mobile_no TEXT,
        cont_phone_no TEXT,
        isSynced INTEGER
      )
    ''');
  }

  // Contact : CRUD operations

  ///insert new record into "contact" table
  static Future<int> insertContact(ContactModel contact) async {
    Database db = await DatabaseHelper().database;
    return await db.insert(
      table,
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  ///select all the rows of "contact" table
  static Future<List<ContactModel>> getAllContacts() async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(table);
    return result.map((e) => ContactModel.fromMap(e)).toList();
  }

  ///select detail of specific person by id
  static Future<ContactModel> getContactById(String uid) async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(table, where: 'uid = ?', whereArgs: [uid]);

    if (result.isNotEmpty) {
      return ContactModel.fromMap(result.first);
    } else {
      throw Exception('Contact not found');
    }
  }

  ///delete record of specific id
  static Future<int> deleteContact(int id) async {
    Database db = await DatabaseHelper().database;
    return await db.delete(table, where: 'uid = ?', whereArgs: [id]);
  }

  ///update contact record by id
  static Future<int> updateContact(ContactModel contact) async {
    try {
      showlog("Inside update contact : ${contact.toJson()}");
      Database db = await DatabaseHelper().database;
      int changedRows = await db.update(
        table,
        contact.toMap(),
        where: 'uid = ?',
        whereArgs: [contact.uid],
      );
      showlog("data updated : $changedRows");
      return changedRows;
    } catch (e) {
      showlog("error on update contact : $e");
      rethrow;
    }
  }
}
