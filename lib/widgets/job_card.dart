import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  final String title;
  final String clientName;
  final String? description;
  final double budget;
  final String? category;
  final String? timePosted;
  final int? applicantCount;
  final VoidCallback? onTap;
  final String? status;

  const JobCard({
    Key? key,
    required this.title,
    required this.clientName,
    this.description,
    required this.budget,
    this.category,
    this.timePosted,
    this.applicantCount,
    this.onTap,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (status != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Posted by: $clientName',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              if (timePosted != null) ...[
                const SizedBox(height: 4),
                Text(
                  timePosted!,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
              if (description != null) ...[
                const SizedBox(height: 12),
                Text(
                  description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${budget.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  if (applicantCount != null)
                    Text(
                      '$applicantCount ${applicantCount == 1 ? 'Applicant' : 'Applicants'}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                ],
              ),
              if (category != null) ...[
                const SizedBox(height: 8),
                Chip(
                  label: Text(category!),
                  padding: const EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.blue[50],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
      case 'open':
        return Colors.green;
      case 'pending':
        return Colors.amber;
      case 'in progress':
        return Colors.blue;
      case 'completed':
        return Colors.purple;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
}
