class RealUserModel {
  final String id;
  final String name;
  final String phone;
  final String? imageUrl;
  final double finalCollection; // ✅ HAR USER KA COLLECTION

  RealUserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.imageUrl,
    required this.finalCollection,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'imageUrl': imageUrl,
      'finalCollection': finalCollection,
    };
  }

  factory RealUserModel.fromMap(Map<dynamic, dynamic> map) {
    final raw = map['finalCollection'];
    double parsedValue = 0.0;
    if (raw is int) {
      parsedValue = raw.toDouble();
    } else if (raw is double) {
      parsedValue = raw;
    } else if (raw is String) {
      parsedValue = double.tryParse(raw) ?? 0.0;
    }

    return RealUserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      imageUrl: map['imageUrl'],
      finalCollection: parsedValue,
    );
  }

}
