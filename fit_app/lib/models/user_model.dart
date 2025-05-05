class UserData {
  final String? name;
  final int age;           // Age is an integer
  final double height;     // Height is a double
  final double weight;     // Weight is a double
  final String gender;

  UserData({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      age: map['age'] as int,  // Ensure age is treated as an integer
      height: map['height'] is int ? (map['height'] as int).toDouble() : map['height'], // Ensure height is treated as a double
      weight: map['weight'] is int ? (map['weight'] as int).toDouble() : map['weight'], // Ensure weight is treated as a double
      gender: map['gender'],
    );
  }
}
