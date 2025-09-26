import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/orders/models/order_model.dart';
import 'package:crm/screen/orders/models/order_product_model.dart';
import 'package:crm/screen/orders/models/order_terms_model.dart';
import 'package:crm/services/local_db.dart';
import 'package:sqflite/sqlite_api.dart';

class OrderRepo {
  static const String orderTable = 'orders';
  static const String orderProductTable = 'orderProduct';
  static const String orderTermsTable = 'orderTerms';

  //initalize all tables
  // static Future<void> initializeTables() async {
  //   try {
  //     Database db = await DatabaseHelper().database;
  //     await createOrderTable(db);
  //     await createOrderProductTable(db);
  //     await createOrderTermsTable(db);
  //   } catch (e) {
  //     showlog("error on initialize orders tables : $e");
  //   }
  // }

  // ---------- Order Table --------
  /// create 'orders' table
  static Future<void> createOrderTable(Database db) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $orderTable (
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

    showlog("after createOrderTable");
  }

  ///inser a new order in [orderTable]
  static Future<int> insertOrder(OrderModel order) async {
    Database db = await DatabaseHelper().database;
    return await db.insert(
      orderTable,
      order.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  ///get all orders from the [orderTable]
  static Future<List<OrderModel>> getAllOrders() async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(orderTable);
    return result.map((e) => OrderModel.fromJson(e)).toList();
  }

  ///get order by id from [orderTable]
  static Future<OrderModel> getOrderById(String id) async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(orderTable, where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return OrderModel.fromJson(result.first);
    } else {
      throw Exception('Order not found');
    }
  }

  ///delete a order record from [orderTable]
  static Future<int> deleteOrder(int id) async {
    Database db = await DatabaseHelper().database;
    return await db.delete(orderTable, where: 'id = ?', whereArgs: [id]);
  }

  ///update an existing order from [orderTable]
  static Future<int> updateOrder(OrderModel order) async {
    try {
      Database db = await DatabaseHelper().database;
      int changedRows = await db.update(
        orderTable,
        order.toJson(),
        where: 'id = ?',
        whereArgs: [order.id],
      );
      return changedRows;
    } catch (e) {
      rethrow;
    }
  }

  // ---------- Order Product Table --------
  static Future<void> createOrderProductTable(Database db) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $orderProductTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId INTEGER,
            productId INTEGER,
            quentity INTEGER,
            isSynced INTEGER
        )
    ''');

    showlog("after createOrderProductTable");
  }

  ///Insert a new order product record into [orderProductTable]
  static Future<int> insertOrderProduct(OrderProductModel orderProduct) async {
    Database db = await DatabaseHelper().database;
    return await db.insert(
      orderProductTable,
      orderProduct.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  ///retrive all order product
  static Future<List<OrderProductModel>> getAllOrderProducts() async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(orderProductTable);
    return result.map((e) => OrderProductModel.fromJson(e)).toList();
  }

  ///retrives a specific order product record by id
  static Future<OrderProductModel> getOrderProductById(int id) async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(
        orderProductTable,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        return OrderProductModel.fromJson(result.first);
      } else {
        throw Exception('Order product not found');
      }
    } catch (e) {
      showlog("Error on get order product by id : $e");
      rethrow;
    }
  }

  ///Updates an existing order record in the 'order table'.
  static Future<int> updateOrderProduct(OrderProductModel orderProduct) async {
    try {
      Database db = await DatabaseHelper().database;
      int changedRows = await db.update(
        orderProductTable,
        orderProduct.toJson(),
        where: 'id = ?',
        whereArgs: [orderProduct.id],
      );
      showlog("orderProduct updated : $changedRows");
      return changedRows;
    } catch (e) {
      showlog("error on update order product : $e");
      rethrow;
    }
  }

  ///Deletes an orderrecord by its ID from the 'orderProducttable.
  static Future<int> deleteOrderProduct(int orderId) async {
    Database db = await DatabaseHelper().database;
    return db.delete(
      orderProductTable,
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }

  // ---------- Order Terms Table --------

  static Future<void> createOrderTermsTable(Database db) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $orderTermsTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId INTEGER,
            termId INTEGER,
            isSynced INTEGER
        )
    ''');

    showlog("after createOrderTermsTable");
  }

  ///Insert a new order terms record into [orderTermsTable]
  static Future<int> insertOrderTerms(OrderTermsModel orderTermsModel) async {
    Database db = await DatabaseHelper().database;
    return await db.insert(
      orderTermsTable,
      orderTermsModel.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  ///delee a term id
  static Future<int> getDeletedTerms(int orderId) async {
    Database db = await DatabaseHelper().database;
    final result = await db.delete(
      orderTermsTable,
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
    return result;
  }

  ///get selected term id
  static Future<List<OrderTermsModel>> getSelectedTerms(int orderId) async {
    Database db = await DatabaseHelper().database;
    final result = await db.query(
      orderTermsTable,
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
    return result.map((e) => OrderTermsModel.fromJson(e)).toList();
  }
}
