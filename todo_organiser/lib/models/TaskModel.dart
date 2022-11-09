class TaskModel {
  final String name;
  final String bucket;
  final int difficulty;

  TaskModel({
    required this.name,
    required this.bucket,
    required this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bucket': bucket,
      'difficulty': difficulty,
    };
  }

  TaskModel.fromMap(Map<String, dynamic> taskMap)
      : name = taskMap["name"],
        bucket = taskMap["bucket"],
        difficulty = taskMap["difficulty"];
}
