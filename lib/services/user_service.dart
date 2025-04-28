import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import '../models/user_model.dart';
import 'auth_service.dart';

class UserService {
  final AuthService _authService = AuthService();

  // Use the same base URL as in AuthService
  final String baseUrl =
      Platform.isAndroid
          ? 'http://10.0.2.2:8001/api'
          : 'http://localhost:8001/api';

  // Get current user profile
  Future<Map<String, dynamic>> getCurrentUser() async {
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
        Uri.parse('$baseUrl/users/me'),
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
          'data': User.fromJson(responseData),
        };
      } else if (response.statusCode == 401) {
        // Token might be expired, try to refresh
        final refreshResult = await _authService.refreshToken();
        if (refreshResult['success']) {
          // Retry with new token
          return getCurrentUser();
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

  // Update user profile
  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> userData,
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
        Uri.parse('$baseUrl/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(userData),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'status': 200,
          'data': User.fromJson(responseData),
        };
      } else if (response.statusCode == 401) {
        // Token might be expired, try to refresh
        final refreshResult = await _authService.refreshToken();
        if (refreshResult['success']) {
          // Retry with new token
          return updateProfile(userData);
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

  // Get freelancer by ID
  Future<Map<String, dynamic>> getFreelancerById(String id) async {
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
        Uri.parse('$baseUrl/users/freelancers/$id'),
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
          'data': User.fromJson(responseData),
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

  // Get top freelancers
  Future<Map<String, dynamic>> getTopFreelancers() async {
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
        Uri.parse('$baseUrl/users/freelancers/top'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> freelancerData = responseData;
        final List<User> freelancers =
            freelancerData.map((json) => User.fromJson(json)).toList();

        return {'success': true, 'status': 200, 'data': freelancers};
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

  // Search freelancers
  Future<Map<String, dynamic>> searchFreelancers(String query) async {
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
        Uri.parse('$baseUrl/users/freelancers/search?q=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> freelancerData = responseData;
        final List<User> freelancers =
            freelancerData.map((json) => User.fromJson(json)).toList();

        return {'success': true, 'status': 200, 'data': freelancers};
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
