class BucketModel {
  final String name;
  final int flexibility;
  final int urgency;
  final int daysLeft;
  final String colour;

  BucketModel({
    required this.name,
    required this.flexibility,
    required this.urgency,
    required this.colour,
    required this.daysLeft,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'flexibility': flexibility,
      'urgency': urgency,
      'days_left': daysLeft,
      'colour': colour,
    };
  }

  BucketModel.fromMap(Map<String, dynamic> bucketMap)
      : name = bucketMap["name"],
        colour = bucketMap["colour"],
        flexibility = bucketMap["flexibility"],
        urgency = bucketMap["urgency"],
        daysLeft = bucketMap["days_left"];
}
