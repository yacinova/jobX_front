import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/user_model.dart';
import '../models/application_model.dart';

class UserProvider with ChangeNotifier {
  final String baseUrl;
  final String? token;
  User? _user;
  List<Application>? _applications;
  bool _isLoading = false;
  String? _error;

  UserProvider({required this.baseUrl, required this.token});

  User? get user => _user;
  List<Application>? get applications => _applications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getUserRole(String userId) async {
    _isLoading = true;
    _error = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        _user = User.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Failed to fetch user data');
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> getApplications() async {
    _isLoading = true;
    _error = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/application'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        _applications = (responseData['data'] as List)
            .map((app) => Application.fromJson(app))
            .toList();
      } else {
        throw Exception(
            responseData['message'] ?? 'Failed to fetch applications');
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}
