class Job {
  final String id;
  final String clientId;
  final String title;
  final String description;
  final String budget;
  final String status;
  final String city;
  final String? domaine;
  final DateTime createdAt;

  Job({
    required this.id,
    required this.clientId,
    required this.title,
    required this.description,
    required this.budget,
    required this.status,
    required this.city,
    this.domaine,
    required this.createdAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'],
      clientId: json['clientId'],
      title: json['title'],
      description: json['description'],
      budget: json['budget'],
      status: json['status'],
      city: json['city'],
      domaine: json['domaine'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
