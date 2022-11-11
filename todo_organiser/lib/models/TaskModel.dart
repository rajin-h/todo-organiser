class TaskModel {
  final String tid;
  final String uid;
  final String name;
  final String bucket;
  final int difficulty;

  TaskModel({
    required this.tid,
    required this.uid,
    required this.name,
    required this.bucket,
    required this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'tid': tid,
      'uid': uid,
      'name': name,
      'bucket': bucket,
      'difficulty': difficulty,
    };
  }

  TaskModel.fromMap(Map<String, dynamic> taskMap, String tid)
      : tid = tid,
        uid = taskMap["uid"],
        name = taskMap["name"],
        bucket = taskMap["bucket"],
        difficulty = taskMap["difficulty"];
}
