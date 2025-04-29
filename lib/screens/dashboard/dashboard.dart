import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/application_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await userProvider.getUserRole(authProvider.userId!);
    await userProvider.getApplications();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final applications = userProvider.applications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userProvider.error != null
              ? Center(child: Text('Error: ${userProvider.error}'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user != null) ...[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User Information',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text('Email: ${user.email}'),
                                Text('Role: ${user.role}'),
                                Text(
                                    'Name: ${user.fullName ?? 'Not Provided'}'),
                                Text(
                                    'Status: ${user.isVerified ? 'Verified' : 'Not Verified'}'),
                                Text(
                                    'Joined: ${user.createdAt.toString().split('T')[0]}'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        'Applications',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      if (applications != null && applications.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: applications.length,
                          itemBuilder: (context, index) {
                            final app = applications[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text('Proposal #${index + 1}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(app.proposalText),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Price: \$${app.proposedPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Status: ${app.status}',
                                      style: TextStyle(
                                        color: app.status == 'pending'
                                            ? Colors.orange
                                            : app.status == 'accepted'
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  app.createdAt.toString().split('T')[0],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            );
                          },
                        )
                      else
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No applications found'),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}
