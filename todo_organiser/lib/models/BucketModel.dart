class BucketModel {
  final String uid;
  final String name;
  final int flexibility;
  final int urgency;
  final int daysLeft;
  final String colour;

  BucketModel({
    required this.uid,
    required this.name,
    required this.flexibility,
    required this.urgency,
    required this.colour,
    required this.daysLeft,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'flexibility': flexibility,
      'urgency': urgency,
      'days_left': daysLeft,
      'colour': colour,
    };
  }

  BucketModel.fromMap(Map<String, dynamic> bucketMap)
      : uid = bucketMap["uid"],
        name = bucketMap["name"],
        colour = bucketMap["colour"],
        flexibility = bucketMap["flexibility"],
        urgency = bucketMap["urgency"],
        daysLeft = bucketMap["days_left"];
}
