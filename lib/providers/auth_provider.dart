import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _userRole;
  bool _isLoading = false;
  bool _mounted = true;

  // Get the base URL depending on the platform
  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8001/api'; // Android emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:8001/api'; // iOS simulator
    } else {
      return 'http://localhost:8001/api'; // Web and other platforms
    }
  }

  bool get mounted => _mounted;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  bool get isAuth => _token != null;
  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get userId => _userId;
  String? get userRole => _userRole;

  void _safeNotifyListeners() {
    Future.microtask(() {
      if (mounted) {
        notifyListeners();
      }
    });
  }

  Future<void> register(
    String email,
    String password,
    String fullName,
    String role,
  ) async {
    _isLoading = true;
    _safeNotifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'fullName': fullName,
          'role': role,
        }),
      );

      final responseData = json.decode(response.body);
      print("responseData-------------$responseData");
      if (response.statusCode == 201) {
        _isLoading = false;
        _safeNotifyListeners();
        return;
      } else {
        throw responseData['message'] ?? 'Registration failed';
      }
    } catch (error) {
      _isLoading = false;
      _safeNotifyListeners();
      throw error.toString();
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    _safeNotifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        _token = responseData['accessToken'];
        _userId = responseData['id'];
        _userRole = responseData['role'];
        _isLoading = false;
        _safeNotifyListeners();

        // Return the response data to pass the id to dashboard
        return {
          'success': true,
          'id': _userId,
          'message': responseData['message'] ?? 'Login successful'
        };
      } else {
        throw responseData['message'] ?? 'Login failed';
      }
    } catch (error) {
      _isLoading = false;
      _safeNotifyListeners();
      throw error.toString();
    }
  }

  Future<void> verifyOTP(String code) async {
    _isLoading = true;
    _safeNotifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'code': code}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        _token = responseData['token'];
        _userId = responseData['id'];
        _isLoading = false;
        _safeNotifyListeners();
      } else {
        throw responseData['message'] ?? 'Verification failed';
      }
    } catch (error) {
      _isLoading = false;
      _safeNotifyListeners();
      throw error.toString();
    }
  }

  void logout() {
    _token = null;
    _userId = null;
    _userRole = null;
    _safeNotifyListeners();
  }

  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    _isLoading = true;
    _safeNotifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        _isLoading = false;
        _safeNotifyListeners();
        return responseData;
      } else {
        throw responseData['message'] ?? 'Failed to fetch user details';
      }
    } catch (error) {
      _isLoading = false;
      _safeNotifyListeners();
      throw error.toString();
    }
  }
}
