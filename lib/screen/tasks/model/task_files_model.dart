class TaskFileModel {
  final int? id;
  final int taskId;
  final String filePath;
  final String? fileType;
  final int isSynced;

  TaskFileModel({
    this.id,
    required this.taskId,
    required this.filePath,
    this.fileType,
    this.isSynced = 0,
  });

  // From JSON (Map)
  factory TaskFileModel.fromJson(Map<String, dynamic> json) {
    return TaskFileModel(
      id: json['id'],
      taskId: json['taskId'],
      filePath: json['filePath'],
      fileType: json['fileType'],
      isSynced: json['isSynced'] ?? 0,
    );
  }

  // For INSERT (includes id only if needed)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, // include only if not null
      'taskId': taskId,
      'filePath': filePath,
      'fileType': fileType,
      'isSynced': isSynced,
    };
  }

  // For UPDATE (never update primary key `id`)
  Map<String, dynamic> toUpdateJson() {
    return {
      'taskId': taskId,
      'filePath': filePath,
      'fileType': fileType,
      'isSynced': isSynced,
    };
  }
}
