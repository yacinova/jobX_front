import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/job_card.dart';
import '../../widgets/freelancer_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  bool _isClient = true; // Default role (can be fetched from API)
  String _username = 'User';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulating API call to get user data
    // In a real app, you would call your API to get user information
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      // Hard-coded for now - in real app this would come from API
      _username = 'John Doe';
      _isClient = true; // This would be determined from user data
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    final result = await _authService.logout();
    if (result['success'] && mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Freelance Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined),
            onPressed: () {
              // Navigate to messages
              // Navigator.of(context).pushNamed('/messages');
            },
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Dashboard'), Tab(text: 'Explore')],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [
                  // Dashboard Tab
                  _buildDashboardTab(),

                  // Explore Tab
                  _buildExploreTab(),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create job or create profile depending on role
          if (_isClient) {
            // Navigate to create job
            // Navigator.of(context).pushNamed('/create-job');
          } else {
            // Navigate to edit profile
            // Navigator.of(context).pushNamed('/edit-profile');
          }
        },
        child: Icon(_isClient ? Icons.add : Icons.edit),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_username),
              accountEmail: Text(_isClient ? 'Client' : 'Freelancer'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  _username.isNotEmpty ? _username[0] : '?',
                  style: const TextStyle(fontSize: 24.0),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.explore),
              title: const Text('Explore'),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to profile
                // Navigator.of(context).pushNamed('/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Messages'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to messages
                // Navigator.of(context).pushNamed('/messages');
              },
            ),
            if (_isClient)
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Job History'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to job history
                  // Navigator.of(context).pushNamed('/job-history');
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.work),
                title: const Text('My Jobs'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to my jobs
                  // Navigator.of(context).pushNamed('/my-jobs');
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
                // Navigator.of(context).pushNamed('/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    if (_isClient) {
      // Client Dashboard
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClientStats(),
            const SizedBox(height: 20),
            _buildSectionTitle('Recent Job Postings'),
            // This would use the JobCard widget with real data
            _buildRecentJobs(),
            const SizedBox(height: 20),
            _buildSectionTitle('Recommended Freelancers'),
            // This would use the FreelancerCard widget with real data
            _buildRecommendedFreelancers(),
          ],
        ),
      );
    } else {
      // Freelancer Dashboard
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFreelancerStats(),
            const SizedBox(height: 20),
            _buildSectionTitle('Job Opportunities'),
            // This would use the JobCard widget with real data
            _buildJobOpportunities(),
            const SizedBox(height: 20),
            _buildSectionTitle('Active Proposals'),
            // This would show the freelancer's active job proposals
            _buildActiveProposals(),
          ],
        ),
      );
    }
  }

  Widget _buildExploreTab() {
    if (_isClient) {
      // Client Explore tab - Find freelancers
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search freelancers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
          ),
          Expanded(child: _buildFreelancerGrid()),
        ],
      );
    } else {
      // Freelancer Explore tab - Find jobs
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search jobs...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
          ),
          Expanded(child: _buildJobGrid()),
        ],
      );
    }
  }

  // Dashboard UI components
  Widget _buildClientStats() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Active Jobs', '3', Icons.work),
            _buildStatItem('Applications', '12', Icons.people),
            _buildStatItem('Messages', '5', Icons.message),
          ],
        ),
      ),
    );
  }

  Widget _buildFreelancerStats() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Projects', '2', Icons.work),
            _buildStatItem('Proposals', '7', Icons.send),
            _buildStatItem('Earnings', '\$1,245', Icons.attach_money),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Placeholder widgets for content
  Widget _buildRecentJobs() {
    // In a real app, this would be populated from API data
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text('Job Title ${index + 1}'),
            subtitle: Text('Posted ${index + 1} day(s) ago'),
            trailing: Text('${(index + 1) * 5} applicants'),
            onTap: () {
              // Navigate to job details
            },
          ),
        );
      },
    );
  }

  Widget _buildRecommendedFreelancers() {
    // In a real app, this would be populated from API data
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(right: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Text('F${index + 1}'),
                  ),
                  const SizedBox(height: 8),
                  Text('Freelancer ${index + 1}'),
                  Text(
                    '⭐ ${4 + index % 2}',
                    style: const TextStyle(color: Colors.amber),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildJobOpportunities() {
    // In a real app, this would be populated from API data
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text('Job Opportunity ${index + 1}'),
            subtitle: Text('Budget: \$${(index + 1) * 100}'),
            trailing: const Chip(label: Text('New')),
            onTap: () {
              // Navigate to job details
            },
          ),
        );
      },
    );
  }

  Widget _buildActiveProposals() {
    // In a real app, this would be populated from API data
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text('Proposal ${index + 1}'),
            subtitle: Text('Sent ${index + 1} day(s) ago'),
            trailing:
                index % 2 == 0
                    ? const Chip(
                      label: Text('Pending'),
                      backgroundColor: Colors.amber,
                    )
                    : const Chip(
                      label: Text('Accepted'),
                      backgroundColor: Colors.green,
                    ),
            onTap: () {
              // Navigate to proposal details
            },
          ),
        );
      },
    );
  }

  Widget _buildFreelancerGrid() {
    // In a real app, this would be populated from API data
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue[100],
                child: Text('F${index + 1}'),
              ),
              const SizedBox(height: 10),
              Text(
                'Freelancer ${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Web Developer', style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 5),
              Text(
                '⭐ ${4 + index % 2}',
                style: const TextStyle(color: Colors.amber),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigate to freelancer details
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('View Profile'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJobGrid() {
    // In a real app, this would be populated from API data
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Job Title ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Posted by Client ${index + 1}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 10),
                Text(
                  'Description goes here, this is a sample job description...',
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${(index + 1) * 100 + 50}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to job details
                    },
                    child: const Text('Apply Now'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
