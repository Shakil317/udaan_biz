class RealUserModel {
  final String id;
  final String name;
  final String phone;
  final String? imageUrl;
  final String? usersCollection;

  RealUserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.imageUrl,
    required this.usersCollection,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'imageUrl': imageUrl,
      'yourCollection': usersCollection,
    };
  }

  factory RealUserModel.fromMap(Map<dynamic, dynamic> map) {
    return RealUserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      imageUrl: map['imageUrl'],
      usersCollection: map['yourCollection']
    );
  }
}
