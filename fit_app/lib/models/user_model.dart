class UserData {
  final String? name;
  final int age;
  final double height;
  final double weight;
  final String gender;
  final String? imageUrl;

  UserData({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'imageUrl': imageUrl,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      age: map['age'] as int,
      height: map['height'] is int ? (map['height'] as int).toDouble() : map['height'],
      weight: map['weight'] is int ? (map['weight'] as int).toDouble() : map['weight'],
      gender: map['gender'],
      imageUrl: map['imageUrl'], 
    );
  }
}
