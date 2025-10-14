import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/login/model/user_model.dart';
import 'package:crm/services/local_db.dart';
import 'package:sqflite/sqflite.dart';

// GoogleSignInAccount:{
//   displayName: mikir parekh,
//   email: mikir281989@gmail.com,
//   id: 105676314157208468101,
//   photoUrl: "https://lh3.googleusercontent.com/a/ACg8ocLhoKJPQFz_lrBNyIiA57nPC8kbrkxv96zuvr6FFxedHs_4_w=s96-c",
//   serverAuthCode: 4/0AVGzR1Apz3hwQe58WuWcjwcg0vFy0vGC4Gd19Ba24eDAmH5D7cshct8uI_aftt2QrNDFVw
// }

class UserRepo {
  static final String tableName = 'users';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        photoUrl TEXT
      )
    ''');
  }

  Future<void> insertUser(UserModel userData) async {
    final db = await DatabaseHelper().database;
    await db.insert(
      tableName,
      userData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel> getUserData() async {
    try {
      final db = await DatabaseHelper().database;
      final result = await db.query(tableName);
      if (result.isNotEmpty) {
        return UserModel.fromJson(result.first);
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      showlog("Eooer getting user details ---> $e");
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    try {
      final db = await DatabaseHelper().database;
      await db.delete(tableName);
    } catch (e) {
      showlog("Error deleting user data: $e");
    }
  }
}
