class Application {
  final String id;
  final String workerId;
  final String proposalText;
  final double proposedPrice;
  final String status;
  final DateTime createdAt;

  Application({
    required this.id,
    required this.workerId,
    required this.proposalText,
    required this.proposedPrice,
    required this.status,
    required this.createdAt,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['_id'],
      workerId: json['workerId'],
      proposalText: json['proposalText'],
      proposedPrice: json['proposedPrice'].toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
