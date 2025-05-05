class DistanceModel {
  final double distance;
  final String timestamp;

  DistanceModel({
    required this.distance,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'distance': distance,
      'timestamp': timestamp,
    };
  }

  factory DistanceModel.fromMap(Map<String, dynamic> map) {
    return DistanceModel(
      distance: map['distance'],
      timestamp: map['timestamp'],
    );
  }
}
