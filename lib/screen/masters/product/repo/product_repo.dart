import 'package:crm/screen/masters/product/model/product_model.dart';
import 'package:crm/services/local_db.dart';
import 'package:sqflite/sqlite_api.dart';

class ProductRepo {
  static const String table = 'product';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_code TEXT UNIQUE,
        product_name TEXT,
        product_uom TEXT,
        product_rate TEXT,
        product_description TEXT,
        product_image TEXT,
        product_document TEXT,
        isSynced INTEGER
        )
    ''');
  }

  // ADD PRODUCT
  static Future<int> addProduct(ProductModel product) async {
    Database db = await DatabaseHelper().database;
    return await db.insert(
      table,
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
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
    return await db.delete(table, where: 'product_id = ?', whereArgs: [id]);
  }

  // GET ALL PRODUCT
  static Future<List<ProductModel>> getAllProducts() async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(table);
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
}
