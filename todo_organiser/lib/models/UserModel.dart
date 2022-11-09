import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final List<String> userBucketRefs;
  final List<String> userTaskRefs;

  UserModel({required this.userBucketRefs, required this.userTaskRefs});

  Map<String, dynamic> toMap() {
    return {
      'buckets': userTaskRefs,
      'tasks': userTaskRefs,
    };
  }

  UserModel.fromMap(Map<String, dynamic> userMap)
      : userBucketRefs = userMap["buckets"],
        userTaskRefs = userMap["tasks"];
}
