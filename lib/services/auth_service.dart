import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class AuthService {
  // Use 10.0.2.2 for Android emulator to connect to localhost on the host machine
  final String baseUrl =
      Platform.isAndroid
          ? 'http://10.0.2.2:8001/api'
          : 'http://localhost:8001/api';

  // Store tokens
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  // Get tokens
  Future<Map<String, String?>> getTokens() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');

    return {'access_token': accessToken, 'refresh_token': refreshToken};
  }

  // Clear tokens
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Check if we have tokens in the response
        if (responseData['accessToken'] != null &&
            responseData['refreshToken'] != null) {
          await saveTokens(
            responseData['accessToken'],
            responseData['refreshToken'],
          );
        }
      }

      return {
        'success': response.statusCode == 200,
        'accessToken': responseData['accessToken'] ?? '',
        'id': responseData['id'] ?? '',
        'message': responseData['message'] ?? 'Unknown error occurred',
      };
    } catch (e) {
      return {
        'success': false,
        'status': 500,
        'data': {'message': e.toString()},
      };
    }
  }

  // Register
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      final responseData = json.decode(response.body);

      return {
        'success': response.statusCode == 201,
        'status': response.statusCode,
        'data': responseData,
      };
    } catch (e) {
      return {
        'success': false,
        'status': 500,
        'data': {'message': e.toString()},
      };
    }
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp(String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'code': otp}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Check if we have tokens in the response
        if (responseData['accessToken'] != null &&
            responseData['refreshToken'] != null) {
          await saveTokens(
            responseData['accessToken'],
            responseData['refreshToken'],
          );
        }
      }

      return {
        'success': response.statusCode == 200,
        'status': response.statusCode,
        'data': responseData,
      };
    } catch (e) {
      return {
        'success': false,
        'status': 500,
        'data': {'message': e.toString()},
      };
    }
  }

  // Resend OTP
  Future<Map<String, dynamic>> resendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/resend-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      final responseData = json.decode(response.body);

      return {
        'success': response.statusCode == 200,
        'status': response.statusCode,
        'data': responseData,
      };
    } catch (e) {
      return {
        'success': false,
        'status': 500,
        'data': {'message': e.toString()},
      };
    }
  }

  // Forgot password
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/resset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      final responseData = json.decode(response.body);

      return {
        'success': response.statusCode == 200,
        'status': response.statusCode,
        'data': responseData,
      };
    } catch (e) {
      return {
        'success': false,
        'status': 500,
        'data': {'message': e.toString()},
      };
    }
  }

  // Verify password reset token
  Future<Map<String, dynamic>> verifyPasswordResetToken(
    String email,
    String token,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verifyPassword'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'token': token}),
      );

      final responseData = json.decode(response.body);

      return {
        'success': response.statusCode == 200,
        'status': response.statusCode,
        'data': responseData,
      };
    } catch (e) {
      return {
        'success': false,
        'status': 500,
        'data': {'message': e.toString()},
      };
    }
  }

  // Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      final tokens = await getTokens();
      final accessToken = tokens['access_token'];

      if (accessToken == null) {
        await clearTokens();
        return {
          'success': true,
          'status': 200,
          'data': {'message': 'Logged out successfully'},
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      await clearTokens();

      final responseData =
          response.statusCode == 200
              ? json.decode(response.body)
              : {'message': 'Logged out successfully'};

      return {'success': true, 'status': 200, 'data': responseData};
    } catch (e) {
      await clearTokens();
      return {
        'success': true,
        'status': 200,
        'data': {'message': 'Logged out successfully'},
      };
    }
  }

  // Refresh token
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final tokens = await getTokens();
      final refreshToken = tokens['refresh_token'];

      if (refreshToken == null) {
        return {
          'success': false,
          'status': 401,
          'data': {'message': 'No refresh token found'},
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh-token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refreshToken': refreshToken}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Store new tokens
        if (responseData['accessToken'] != null &&
            responseData['refreshToken'] != null) {
          await saveTokens(
            responseData['accessToken'],
            responseData['refreshToken'],
          );
        }

        return {'success': true, 'status': 200, 'data': responseData};
      } else {
        // Clear tokens if refresh failed
        await clearTokens();

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

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final tokens = await getTokens();
    return tokens['access_token'] != null;
  }
}
