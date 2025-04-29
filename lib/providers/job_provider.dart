import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobProvider with ChangeNotifier {
  List<dynamic> _jobs = [];
  bool _isLoading = false;
  String? _error;

  List<dynamic> get jobs => _jobs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchJobs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
            'YOUR_API_ENDPOINT/jobs'), // Replace with your actual API endpoint
        headers: {
          'Content-Type': 'application/json',
          // Add authorization header if needed
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _jobs = data['jobs'] ?? [];
      } else {
        _error = 'Failed to fetch jobs: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching jobs: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
