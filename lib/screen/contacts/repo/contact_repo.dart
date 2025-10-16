import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_snackbars.dart';
import 'package:crm/screen/contacts/model/contact_model.dart';
import 'package:crm/services/local_db.dart';
import 'package:sqflite/sqlite_api.dart';

//TODO: add email warning -- if email exist warn on ui
class ContactsRepo {
  static const String table = 'contact';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        created_by TEXT,
        updated_by TEXT,
        cust_name TEXT,
        address TEXT,
        city TEXT,
        state TEXT,
        district TEXT,
        country TEXT,
        pincode TEXT,
        mobile_no TEXT UNIQUE,
        email TEXT UNIQUE,
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
        created_at TEXT,
        updated_at TEXT,
        isSynced INTEGER DEFAULT 0
      )
    ''');
  }

  // Contact : CRUD operations

  ///insert new record into "contact" table
  static Future<int> insertContact(ContactModel contact) async {
    Database db = await DatabaseHelper().database;
    int newId = await db.insert(
      table,
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return newId;
  }

  ///select all the rows of "contact" table
  static Future<List<ContactModel>> getAllContacts() async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(
      table,
      where: 'isSynced != ?',
      whereArgs: [2],
    );
    return result.map((e) => ContactModel.fromMap(e)).toList();
  }

  ///select detail of specific person by id
  static Future<ContactModel> getContactById(String id) async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(table, where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return ContactModel.fromMap(result.first);
    } else {
      throw Exception('Contact not found');
    }
  }

  ///delete record of specific id
  static Future<int> deleteContact(int id) async {
    Database db = await DatabaseHelper().database;

    // return await db.delete(table, where: 'id = ?', whereArgs: [id]);

    // update isSynced to 2
    return await db.update(
      table,
      {'isSynced': 2},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  ///update contact record by id
  static Future<int> updateContact(ContactModel contact) async {
    try {
      AppUtils.showlog("Inside update contact : ${contact.toJson()}");
      Database db = await DatabaseHelper().database;
      int changedRows = await db.update(
        table,
        contact.toMap(),
        where: 'id = ?',
        whereArgs: [contact.id],
      );
      AppUtils.showlog("data updated : $changedRows");
      return changedRows;
    } catch (e) {
      AppUtils.showlog("error on update contact : $e");
      rethrow;
    }
  }

  // -------------------------------------------------------------------------
  // --------------  MARK: upload to firestore
  //--------------------------------------------------------------------------

  //TODO: check ignore/replace conflict

  final _firestore = FirebaseFirestore.instance;

  Future<void> syncContactsToFirestore() async {
    try {
      await uploadToFirestore();
      AppUtils.showlog("Contact : After uploadToFirestore");

      await downloadFromFirestore();
      AppUtils.showlog("Contact : After downloadFromFirestore");
    } catch (e) {
      AppUtils.showlog("Error syncing contacts to Firestore: $e");
      showErrorSnackBar("Error syncing contacts to cloud");
    }
  }

  /// Upload local changes to Firestore
  Future<void> uploadToFirestore() async {
    // update database isSynced to 1 --> upload
    // if success keep it 1
    // else isSynced = 0 (revert)
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

        // Update local record only after success
        // await db.update(
        //   table,
        //   {'isSynced': 1},
        //   where: 'id = ?',
        //   whereArgs: [record['id']],
        // );
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

  /// Download changes from Firestore to local SQLite
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
        // Insert if not present locally
        await db.insert(table, {
          'created_by': data['created_by'],
          'updated_by': data['updated_by'],
          'cust_name': data['cust_name'],
          'address': data['address'],
          'city': data['city'],
          'state': data['state'],
          'district': data['district'],
          'country': data['country'],
          'pincode': data['pincode'],
          'mobile_no': data['mobile_no'],
          'email': data['email'],
          'website': data['website'],
          'business_type': data['business_type'],
          'industry_type': data['industry_type'],
          'status': data['status'],
          'contact_name': data['contact_name'],
          'department': data['department'],
          'designation': data['designation'],
          'cont_email': data['cont_email'],
          'cont_mobile_no': data['cont_mobile_no'],
          'cont_phone_no': data['cont_phone_no'],
          'created_at': data['created_at'],
          'updated_at': data['updated_at'],
          'isSynced': 1,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      } else {
        // Update local record if Firestore version is newer
        await db.update(
          table,
          {
            'created_by': data['created_by'],
            'updated_by': data['updated_by'],
            'cust_name': data['cust_name'],
            'address': data['address'],
            'city': data['city'],
            'state': data['state'],
            'district': data['district'],
            'country': data['country'],
            'pincode': data['pincode'],
            'mobile_no': data['mobile_no'],
            'email': data['email'],
            'website': data['website'],
            'business_type': data['business_type'],
            'industry_type': data['industry_type'],
            'status': data['status'],
            'contact_name': data['contact_name'],
            'department': data['department'],
            'designation': data['designation'],
            'cont_email': data['cont_email'],
            'cont_mobile_no': data['cont_mobile_no'],
            'cont_phone_no': data['cont_phone_no'],
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
