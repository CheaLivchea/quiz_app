import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quiz_app/features/auth/utils/token_manager.dart';
import 'package:quiz_app/features/profile/models/user_data.dart';

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

      final response = await http.post(
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
        // Handle different response types
        try {
          final errorData = json.decode(response.body);
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to update profile',
          };
        } catch (e) {
          // If response is not JSON (like HTML error page)
          return {
            'success': false,
            'message':
                'Server error: ${response.statusCode}. Please try again.',
          };
        }
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
      print('🔑 Using token: ${token.substring(0, 20)}...');

      final requestBody = {
        'password': newPassword, // API expects just 'password' field
      };

      print('📤 Request Body: ${json.encode(requestBody)}');
      print(
        '📤 Request Headers: {Content-Type: application/json, Authorization: Bearer ${token.substring(0, 20)}...}',
      );

      // Try with different request formats to match Postman
      final response = await http.post(
        Uri.parse(changePasswordEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      print('📱 Change Password Response Status: ${response.statusCode}');
      print('📱 Change Password Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Password changed successfully'};
      } else {
        // Handle different response types
        try {
          final errorData = json.decode(response.body);
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to change password',
          };
        } catch (e) {
          // If response is not JSON (like HTML error page)
          return {
            'success': false,
            'message':
                'Server error: ${response.statusCode}. Please check your credentials.',
          };
        }
      }
    } catch (e) {
      print('❌ Change Password Error: $e');
      return {'success': false, 'message': 'Error changing password: $e'};
    }
  }
}
