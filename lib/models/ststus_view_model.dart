class StatusViewModel {
  final String mediaUrl;
  final String name;
  final String phone;
  final String type;

  StatusViewModel({
    required this.mediaUrl,
    required this.name,
    required this.phone,
    required this.type,
  });

  factory StatusViewModel.fromMap(Map<String, dynamic> map) {
    return StatusViewModel(
      mediaUrl: map['mediaUrl'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      type: map['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mediaUrl': mediaUrl,
      'name': name,
      'phone': phone,
      'type': type,
    };
  }
}
