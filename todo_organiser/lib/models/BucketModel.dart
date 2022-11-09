class BucketModel {
  final String name;
  final int flexibility;
  final int urgency;
  final int daysLeft;

  BucketModel({
    required this.name,
    required this.flexibility,
    required this.urgency,
    required this.daysLeft,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'flexibility': flexibility,
      'urgency': urgency,
      'days_left': daysLeft,
    };
  }

  BucketModel.fromMap(Map<String, dynamic> bucketMap)
      : name = bucketMap["name"],
        flexibility = bucketMap["flexibility"],
        urgency = bucketMap["urgency"],
        daysLeft = bucketMap["days_left"];
}
