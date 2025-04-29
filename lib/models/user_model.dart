class User {
  final String id;
  final String email;
  final bool isVerified;
  final String role;
  final DateTime createdAt;
  final String firstName;
  final String lastName;

  User({
    required this.id,
    required this.email,
    required this.isVerified,
    required this.role,
    required this.createdAt,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      isVerified: json['isVerified'],
      role: json['role'],
      createdAt: DateTime.parse(json['createdAt']),
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }
}
