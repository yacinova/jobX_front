class Job {
  final String id;
  final String title;
  final String description;
  final String clientId;
  final String clientName;
  final double budget;
  final String status; // 'open', 'in progress', 'completed', 'cancelled'
  final DateTime postedDate;
  final DateTime? deadline;
  final String category;
  final List<String> skills;
  final int applicationCount;
  final String? workerId;
  final String? workerName;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.clientId,
    required this.clientName,
    required this.budget,
    required this.status,
    required this.postedDate,
    this.deadline,
    required this.category,
    required this.skills,
    required this.applicationCount,
    this.workerId,
    this.workerName,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      clientId: json['clientId'] ?? '',
      clientName: json['clientName'] ?? '',
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'open',
      postedDate:
          json['postedDate'] != null
              ? DateTime.parse(json['postedDate'])
              : DateTime.now(),
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      category: json['category'] ?? '',
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      applicationCount: json['applicationCount'] ?? 0,
      workerId: json['workerId'],
      workerName: json['workerName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'clientId': clientId,
      'clientName': clientName,
      'budget': budget,
      'status': status,
      'postedDate': postedDate.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'category': category,
      'skills': skills,
      'applicationCount': applicationCount,
      'workerId': workerId,
      'workerName': workerName,
    };
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(postedDate);

    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  Job copyWith({
    String? id,
    String? title,
    String? description,
    String? clientId,
    String? clientName,
    double? budget,
    String? status,
    DateTime? postedDate,
    DateTime? deadline,
    String? category,
    List<String>? skills,
    int? applicationCount,
    String? workerId,
    String? workerName,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      budget: budget ?? this.budget,
      status: status ?? this.status,
      postedDate: postedDate ?? this.postedDate,
      deadline: deadline ?? this.deadline,
      category: category ?? this.category,
      skills: skills ?? this.skills,
      applicationCount: applicationCount ?? this.applicationCount,
      workerId: workerId ?? this.workerId,
      workerName: workerName ?? this.workerName,
    );
  }
}
