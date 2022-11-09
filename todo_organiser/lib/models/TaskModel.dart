class TaskModel {
  final String uid;
  final String name;
  final String bucket;
  final int difficulty;

  TaskModel({
    required this.uid,
    required this.name,
    required this.bucket,
    required this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'bucket': bucket,
      'difficulty': difficulty,
    };
  }

  TaskModel.fromMap(Map<String, dynamic> taskMap)
      : uid = taskMap["uid"],
        name = taskMap["name"],
        bucket = taskMap["bucket"],
        difficulty = taskMap["difficulty"];
}
