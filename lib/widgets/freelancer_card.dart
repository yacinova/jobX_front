import 'package:flutter/material.dart';

class FreelancerCard extends StatelessWidget {
  final String name;
  final String profession;
  final String? imageUrl;
  final double? rating;
  final int? jobsCompleted;
  final String? location;
  final VoidCallback? onTap;
  final VoidCallback? onHire;

  const FreelancerCard({
    Key? key,
    required this.name,
    required this.profession,
    this.imageUrl,
    this.rating,
    this.jobsCompleted,
    this.location,
    this.onTap,
    this.onHire,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile image
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue[100],
                backgroundImage:
                    imageUrl != null ? NetworkImage(imageUrl!) : null,
                child:
                    imageUrl == null
                        ? Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                        : null,
              ),
              const SizedBox(height: 12),

              // Name
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),

              // Profession
              Text(
                profession,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                textAlign: TextAlign.center,
              ),

              // Rating
              if (rating != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(
                      ' ${rating!.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],

              // Jobs completed
              if (jobsCompleted != null) ...[
                const SizedBox(height: 4),
                Text(
                  '$jobsCompleted ${jobsCompleted == 1 ? 'Job' : 'Jobs'} Completed',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],

              // Location
              if (location != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, color: Colors.grey[600], size: 14),
                    Text(
                      ' $location',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],

              // Hire button
              if (onHire != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onHire,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View Profile'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
