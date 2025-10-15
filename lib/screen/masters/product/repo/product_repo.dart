import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_snackbars.dart';
import 'package:crm/screen/masters/product/model/product_model.dart';
import 'package:crm/services/local_db.dart';
import 'package:sqflite/sqlite_api.dart';

class ProductRepo {
  static const String table = 'product';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        created_by TEXT,
        updated_by TEXT,
        product_code TEXT UNIQUE,
        product_name TEXT,
        product_uom TEXT,
        product_rate TEXT,
        product_description TEXT,
        product_image TEXT,
        product_document TEXT,
        created_at TEXT,
        updated_at TEXT,
        isSynced INTEGER DEFAULT 0
        )
    ''');
  }

  // ADD PRODUCT
  static Future<int> addProduct(ProductModel product) async {
    Database db = await DatabaseHelper().database;
    return await db.insert(
      table,
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // UPDATE PRODUCT
  static Future<int> updateProduct(ProductModel product) async {
    Database db = await DatabaseHelper().database;
    return await db.update(
      table,
      product.toJson(),
      where: 'product_id = ?',
      whereArgs: [product.productId],
    );
  }

  // DELETE PRODUCT
  static Future<int> deleteProduct(int id) async {
    Database db = await DatabaseHelper().database;
    // return await db.delete(table, where: 'product_id = ?', whereArgs: [id]);

    //update isSynced to 2
    return await db.update(
      table,
      {'isSynced': 2},
      where: 'product_id = ?',
      whereArgs: [id],
    );
  }

  // GET ALL PRODUCT
  static Future<List<ProductModel>> getAllProducts() async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(
      table,
      where: 'isSynced != ?',
      whereArgs: [2],
    );
    return result.map((e) => ProductModel.fromJson(e)).toList();
  }

  // GET PRODUCT BY ID
  static Future<ProductModel> getProductById(int id) async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(
      table,
      where: 'product_id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return ProductModel.fromJson(result.first);
    } else {
      throw Exception('Product not found');
    }
  }

  // -------------------------------------------------------------------------
  // --------------  MARK: upload to firestore
  //--------------------------------------------------------------------------

  final _firestore = FirebaseFirestore.instance;

  Future<void> syncProductsToFirestore() async {
    try {
      await uploadToFirestore();
      AppUtils.showlog("After uploadToFirestore");

      await downloadFromFirestore();
      AppUtils.showlog("After downloadFromFirestore");
    } catch (e) {
      AppUtils.showlog("Error syncing contacts to Firestore: $e");
      showErrorSnackBar("Error syncing contacts to cloud");
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
        // Insert if not present locally
        await db.insert(table, {
          'created_by': data['created_by'],
          'updated_by': data['updated_by'],
          'product_code': data['product_code'],
          'product_name': data['product_name'],
          'product_uom': data['product_uom'],
          'product_rate': data['product_rate'],
          'product_description': data['product_description'],
          'product_image': data['product_image'],
          'product_document': data['product_document'],
          'created_at': data['created_at'],
          'updated_at': data['updated_at'],
          'isSynced': 1,
        });
      } else {
        // Update local record if Firestore version is newer
        await db.update(
          table,
          {
            'created_by': data['created_by'],
            'updated_by': data['updated_by'],
            'product_code': data['product_code'],
            'product_name': data['product_name'],
            'product_uom': data['product_uom'],
            'product_rate': data['product_rate'],
            'product_description': data['product_description'],
            'product_image': data['product_image'],
            'product_document': data['product_document'],
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
