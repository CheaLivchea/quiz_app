import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quiz_app/features/auth/utils/token_manager.dart';

class UserService {
  static String get getUserInfoEndpoint => dotenv.env['GET_INFO'] ?? '';
  static String get updateInfoEndpoint => dotenv.env['UPDATE_INFO'] ?? '';
  static String get changePasswordEndpoint =>
      dotenv.env['CHANGE_PASSWORD'] ?? '';

  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final tokenManager = TokenManager();

      // Check if token is valid
      if (!await tokenManager.isTokenValid()) {
        print('❌ Token expired or invalid. User needs to login again.');
        return {
          'success': false,
          'message': 'Your session has expired. Please log in again.',
          'requiresAuth': true,
        };
      }

      final token = await tokenManager.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'No authentication token found. Please log in.',
          'requiresAuth': true,
        };
      }

      print('🔄 Fetching user info from: $getUserInfoEndpoint');

      final response = await http.get(
        Uri.parse(getUserInfoEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📱 User Info Response Status: ${response.statusCode}');
      print('📱 User Info Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': UserData.fromJson(data)};
      } else {
        return {
          'success': false,
          'message': 'Failed to load user info: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('❌ User Service Error: $e');
      return {'success': false, 'message': 'Error loading user info: $e'};
    }
  }

  Future<Map<String, dynamic>> updateUserInfo({
    required String firstName,
    required String lastName,
    String? username,
  }) async {
    try {
      final tokenManager = TokenManager();

      // Check if token is valid
      if (!await tokenManager.isTokenValid()) {
        print('❌ Token expired or invalid. User needs to login again.');
        return {
          'success': false,
          'message': 'Your session has expired. Please log in again.',
          'requiresAuth': true,
        };
      }

      final token = await tokenManager.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'No authentication token found. Please log in.',
          'requiresAuth': true,
        };
      }

      print('🔄 Updating user info at: $updateInfoEndpoint');
      print('🔑 Using token: ${token.substring(0, 20)}...');

      final body = {'firstName': firstName, 'lastName': lastName};

      if (username != null && username.isNotEmpty) {
        body['username'] = username;
      }

      final response = await http.put(
        Uri.parse(updateInfoEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      print('📱 Update Profile Response Status: ${response.statusCode}');
      print('📱 Update Profile Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': 'Profile updated successfully',
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to update profile: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('❌ Update Profile Error: $e');
      return {'success': false, 'message': 'Error updating profile: $e'};
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final tokenManager = TokenManager();

      // Check if token is valid
      if (!await tokenManager.isTokenValid()) {
        print('❌ Token expired or invalid. User needs to login again.');
        return {
          'success': false,
          'message': 'Your session has expired. Please log in again.',
          'requiresAuth': true,
        };
      }

      final token = await tokenManager.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'No authentication token found. Please log in.',
          'requiresAuth': true,
        };
      }

      print('🔄 Changing password at: $changePasswordEndpoint');
      print(
        '🔑 Using token: ${token.substring(0, 20)}...',
      ); // Show first 20 chars of token

      final response = await http.post(
        Uri.parse(changePasswordEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      print('📱 Change Password Response Status: ${response.statusCode}');
      print('📱 Change Password Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Password changed successfully'};
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to change password',
        };
      }
    } catch (e) {
      print('❌ Change Password Error: $e');
      return {'success': false, 'message': 'Error changing password: $e'};
    }
  }
}

class UserData {
  final int id;
  final String? username;
  final String countryCode;
  final String phone;
  final String firstName;
  final String lastName;
  final String? status;
  final String? lastSeenAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserData({
    required this.id,
    this.username,
    required this.countryCode,
    required this.phone,
    required this.firstName,
    required this.lastName,
    this.status,
    this.lastSeenAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      username: json['username'],
      countryCode: json['countryCode'] ?? '',
      phone: json['phone'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      status: json['status'],
      lastSeenAt: json['lastSeenAt'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Helper method to get display name
  String get displayName {
    if (username != null && username!.isNotEmpty) {
      return username!;
    }
    return '$firstName $lastName'.trim();
  }

  // Helper method to get full name
  String get fullName {
    return '$firstName $lastName'.trim();
  }

  // Helper method to get phone with country code
  String get fullPhone {
    return '+$countryCode $phone';
  }

  // Helper method to get phone with country name
  String get formattedPhone {
    String countryName = _getCountryName(countryCode);
    return '+$countryCode $phone ($countryName)';
  }

  // Helper method to get country name from code
  String _getCountryName(String code) {
    switch (code) {
      case '855':
        return 'Cambodia';
      case '1':
        return 'USA';
      case '86':
        return 'China';
      case '81':
        return 'Japan';
      case '82':
        return 'South Korea';
      case '66':
        return 'Thailand';
      case '84':
        return 'Vietnam';
      default:
        return 'Unknown';
    }
  }
}
