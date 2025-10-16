class TasksModel {
  final int? id;
  final String date;
  final String description;
  final String work;
  final double assignedTo;
  final String? filePath;
  final int isSynced;

  TasksModel({
    this.id,
    required this.date,
    required this.description,
    required this.work,
    required this.assignedTo,
    this.filePath,
    this.isSynced = 0,
  });

  // Convert a Map (from SQLite) to TasksModel
  factory TasksModel.fromMap(Map<String, dynamic> map) {
    return TasksModel(
      id: map['id'],
      date: map['date'],
      description: map['description'],
      work: map['work'],
      assignedTo: map['assignedTo'],
      filePath: map['filePath'],
      isSynced: map['isSynced'] ?? 0,
    );
  }

  // Convert TasksModel to Map (for SQLite insert/update)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'description': description,
      'work': work,
      'assignedTo': assignedTo,
      'filePath': filePath,
      'isSynced': isSynced,
    };
  }
}
