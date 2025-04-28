class User {
  final String id;
  final String name;
  final String email;
  final bool isVerified;
  final String userType; // 'client' or 'worker'
  final String? profileImage;
  final String? bio;
  final String? location;
  final List<String>? skills;
  final double? rating;
  final int? completedJobs;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isVerified,
    required this.userType,
    this.profileImage,
    this.bio,
    this.location,
    this.skills,
    this.rating,
    this.completedJobs,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isVerified: json['isVerified'] ?? false,
      userType: json['userType'] ?? 'client',
      profileImage: json['profileImage'],
      bio: json['bio'],
      location: json['location'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      rating: json['rating']?.toDouble(),
      completedJobs: json['completedJobs'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isVerified': isVerified,
      'userType': userType,
      'profileImage': profileImage,
      'bio': bio,
      'location': location,
      'skills': skills,
      'rating': rating,
      'completedJobs': completedJobs,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isClient => userType == 'client';
  bool get isWorker => userType == 'worker';

  User copyWith({
    String? id,
    String? name,
    String? email,
    bool? isVerified,
    String? userType,
    String? profileImage,
    String? bio,
    String? location,
    List<String>? skills,
    double? rating,
    int? completedJobs,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      userType: userType ?? this.userType,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      skills: skills ?? this.skills,
      rating: rating ?? this.rating,
      completedJobs: completedJobs ?? this.completedJobs,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
