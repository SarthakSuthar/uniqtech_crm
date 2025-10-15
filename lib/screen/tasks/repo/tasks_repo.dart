import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/tasks/model/task_files_model.dart';
import 'package:crm/screen/tasks/model/tasks_model.dart';
import 'package:crm/services/local_db.dart';
import 'package:sqflite/sqlite_api.dart';

class TasksRepo {
  static const taskTable = 'tasks';
  static const taskFilesTable = 'task_files';

  static Future<void> createTaskTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $taskTable (
      id INTEGER PRIMARY KEY,
      date TEXT,
      description TEXT,
      work TEXT,
      assignedTo INTEGER,
      filePath TEXT,
      isSynced INTEGER DEFAULT 0,
      FOREIGN KEY (assignedTo) REFERENCES users (uid) ON DELETE CASCADE
    )
  ''');
  }

  ///insert into tasks table
  static Future<int> insertTask(TasksModel task) async {
    try {
      Database db = await DatabaseHelper().database;
      return await db.insert(
        taskTable,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      AppUtils.showlog("Error inserting task: $e");
      return 0;
    }
  }

  Future<int> getNextTaskId() async {
    Database db = await DatabaseHelper().database;
    final result = await db.rawQuery('SELECT MAX(id) FROM $taskTable');
    int? maxId = result.first['MAX(id)'] as int?;
    return (maxId ?? 0) + 1;
  }

  ///get all task list
  static Future<List<TasksModel>> getAllTasks() async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(taskTable);
      return result.map((e) => TasksModel.fromMap(e)).toList();
    } catch (e) {
      AppUtils.showlog("error getting tasks list: $e");
      return [];
    }
  }

  ///get task details by id
  static Future<TasksModel> getTaskById(int id) async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(
        taskTable,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        return TasksModel.fromMap(result.first);
      } else {
        throw Exception('Task not found');
      }
    } catch (e) {
      AppUtils.showlog("error getting task by id: $e");
      rethrow;
    }
  }

  ///update task details
  static Future<int> updateTask(TasksModel task) async {
    try {
      Database db = await DatabaseHelper().database;
      return await db.update(
        taskTable,
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    } catch (e) {
      AppUtils.showlog("error updating task: $e");
      rethrow;
    }
  }

  ///delete task
  static Future<int> deleteTask(int id) async {
    try {
      Database db = await DatabaseHelper().database;
      return await db.delete(taskTable, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      AppUtils.showlog("error deleting task: $e");
      rethrow;
    }
  }

  // --------- task file ----------

  static Future<void> createTaskFilesTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $taskFilesTable (
      id INTEGER PRIMARY KEY,
      taskId INTEGER,
      filePath TEXT,
      fileType TEXT, -- (optional: image/pdf/doc)
      isSynced INTEGER DEFAULT 0,
      FOREIGN KEY (taskId) REFERENCES tasks (id) ON DELETE CASCADE
    )
  ''');
  }

  ///insert
  static Future<int> insertTaskFile(TaskFileModel taskFile) async {
    try {
      Database db = await DatabaseHelper().database;
      return await db.insert(
        taskFilesTable,
        taskFile.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      AppUtils.showlog("error inserting task file: $e");
      rethrow;
    }
  }

  ///get all files
  static Future<List<TaskFileModel>> getAllTaskFiles() async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(taskFilesTable);
      AppUtils.showlog(
        "files list : ${result.map((e) => TaskFileModel.fromJson(e)).toList()}",
      );
      return result.map((e) => TaskFileModel.fromJson(e)).toList();
    } catch (e) {
      AppUtils.showlog("error getting task files list: $e");
      return [];
    }
  }

  ///get file by task id
  static Future<TaskFileModel> getTaskFileByTaskId(int taskId) async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(
        taskFilesTable,
        where: 'taskId = ?',
        whereArgs: [taskId],
      );
      if (result.isNotEmpty) {
        return TaskFileModel.fromJson(result.first);
      } else {
        throw Exception('Task file not found');
      }
    } catch (e) {
      AppUtils.showlog("error getting task file by task id: $e");
      rethrow;
    }
  }

  ///delete
  static Future<int> deleteTaskFile(int taskId) async {
    try {
      Database db = await DatabaseHelper().database;
      return await db.delete(
        taskFilesTable,
        where: 'taskId = ?',
        whereArgs: [taskId],
      );
    } catch (e) {
      AppUtils.showlog("Error deleting task file: $e");
      rethrow;
    }
  }

  ///update
  static Future<int> updateTaskFile(TaskFileModel taskFile) async {
    try {
      Database db = await DatabaseHelper().database;
      return await db.update(
        taskFilesTable,
        taskFile.toUpdateJson(),
        where: 'taskId = ?',
        whereArgs: [taskFile.taskId],
      );
    } catch (e) {
      AppUtils.showlog("Error updating task file: $e");
      rethrow;
    }
  }
}
