class User {
  final String id;
  final String email;
  final bool isVerified;
  final String role;
  final DateTime createdAt;
  final String fullName;

  User({
    required this.id,
    required this.email,
    required this.isVerified,
    required this.role,
    required this.createdAt,
    required this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      isVerified: json['isVerified'],
      role: json['role'],
      createdAt: DateTime.parse(json['createdAt']),
      fullName: json['fullName'] ?? '',
    );
  }
}
