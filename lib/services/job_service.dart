import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import '../models/job_model.dart';
import 'auth_service.dart';

class JobService {
  final AuthService _authService = AuthService();

  // Use the same base URL as in AuthService
  final String baseUrl =
      Platform.isAndroid
          ? 'http://10.0.2.2:8001/api'
          : 'http://localhost:8001/api';

  // Get all jobs
  Future<Map<String, dynamic>> getAllJobs() async {
    try {
      final tokens = await _authService.getTokens();
      final accessToken = tokens['access_token'];

      if (accessToken == null) {
        return {
          'success': false,
          'status': 401,
          'data': {'message': 'Not authenticated'},
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/jobs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> jobsData = responseData;
        final List<Job> jobs =
            jobsData.map((json) => Job.fromJson(json)).toList();

        return {'success': true, 'status': 200, 'data': jobs};
      } else if (response.statusCode == 401) {
        // Token might be expired, try to refresh
        final refreshResult = await _authService.refreshToken();
        if (refreshResult['success']) {
          // Retry with new token
          return getAllJobs();
        } else {
          return {
            'success': false,
            'status': 401,
            'data': {'message': 'Authentication failed'},
          };
        }
      } else {
        return {
          'success': false,
          'status': response.statusCode,
          'data': responseData,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'status': 500,
        'data': {'message': e.toString()},
      };
    }
  }

  // Create a new job
  Future<Map<String, dynamic>> createJob(Map<String, dynamic> jobData) async {
    try {
      final tokens = await _authService.getTokens();
      final accessToken = tokens['access_token'];

      if (accessToken == null) {
        return {
          'success': false,
          'status': 401,
          'data': {'message': 'Not authenticated'},
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/jobs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(jobData),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'status': 201,
          'data': Job.fromJson(responseData),
        };
      } else {
        return {
          'success': false,
          'status': response.statusCode,
          'data': responseData,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'status': 500,
        'data': {'message': e.toString()},
      };
    }
  }

  // Get job by ID
  Future<Map<String, dynamic>> getJobById(String id) async {
    try {
      final tokens = await _authService.getTokens();
      final accessToken = tokens['access_token'];

      if (accessToken == null) {
        return {
          'success': false,
          'status': 401,
          'data': {'message': 'Not authenticated'},
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/jobs/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'status': 200,
          'data': Job.fromJson(responseData),
        };
      } else {
        return {
          'success': false,
          'status': response.statusCode,
          'data': responseData,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'status': 500,
        'data': {'message': e.toString()},
      };
    }
  }

  // Update job
  Future<Map<String, dynamic>> updateJob(
    String id,
    Map<String, dynamic> jobData,
  ) async {
    try {
      final tokens = await _authService.getTokens();
      final accessToken = tokens['access_token'];

      if (accessToken == null) {
        return {
          'success': false,
          'status': 401,
          'data': {'message': 'Not authenticated'},
        };
      }

      final response = await http.put(
        Uri.parse('$baseUrl/jobs/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(jobData),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'status': 200,
          'data': Job.fromJson(responseData),
        };
      } else {
        return {
          'success': false,
          'status': response.statusCode,
          'data': responseData,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'status': 500,
        'data': {'message': e.toString()},
      };
    }
  }

  // Delete job
  Future<Map<String, dynamic>> deleteJob(String id) async {
    try {
      final tokens = await _authService.getTokens();
      final accessToken = tokens['access_token'];

      if (accessToken == null) {
        return {
          'success': false,
          'status': 401,
          'data': {'message': 'Not authenticated'},
        };
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/jobs/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 204) {
        return {
          'success': true,
          'status': 204,
          'data': {'message': 'Job deleted successfully'},
        };
      } else {
        final responseData = json.decode(response.body);
        return {
          'success': false,
          'status': response.statusCode,
          'data': responseData,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'status': 500,
        'data': {'message': e.toString()},
      };
    }
  }

  // Get my posted jobs (for clients)
  Future<Map<String, dynamic>> getMyJobs() async {
    try {
      final tokens = await _authService.getTokens();
      final accessToken = tokens['access_token'];

      if (accessToken == null) {
        return {
          'success': false,
          'status': 401,
          'data': {'message': 'Not authenticated'},
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/jobs/my-jobs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> jobsData = responseData;
        final List<Job> jobs =
            jobsData.map((json) => Job.fromJson(json)).toList();

        return {'success': true, 'status': 200, 'data': jobs};
      } else {
        return {
          'success': false,
          'status': response.statusCode,
          'data': responseData,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'status': 500,
        'data': {'message': e.toString()},
      };
    }
  }

  // Search jobs
  Future<Map<String, dynamic>> searchJobs(String query) async {
    try {
      final tokens = await _authService.getTokens();
      final accessToken = tokens['access_token'];

      if (accessToken == null) {
        return {
          'success': false,
          'status': 401,
          'data': {'message': 'Not authenticated'},
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/jobs/search?q=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> jobsData = responseData;
        final List<Job> jobs =
            jobsData.map((json) => Job.fromJson(json)).toList();

        return {'success': true, 'status': 200, 'data': jobs};
      } else {
        return {
          'success': false,
          'status': response.statusCode,
          'data': responseData,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'status': 500,
        'data': {'message': e.toString()},
      };
    }
  }

  // Apply for a job (for freelancers)
  Future<Map<String, dynamic>> applyForJob(
    String jobId,
    Map<String, dynamic> applicationData,
  ) async {
    try {
      final tokens = await _authService.getTokens();
      final accessToken = tokens['access_token'];

      if (accessToken == null) {
        return {
          'success': false,
          'status': 401,
          'data': {'message': 'Not authenticated'},
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/jobs/$jobId/apply'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(applicationData),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'status': 201, 'data': responseData};
      } else {
        return {
          'success': false,
          'status': response.statusCode,
          'data': responseData,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'status': 500,
        'data': {'message': e.toString()},
      };
    }
  }
}
