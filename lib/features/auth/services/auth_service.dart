import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/constants/hold_token.dart';

class AuthService {
  static String get loginEndpoint => dotenv.env['LOGIN'] ?? '';
  static String get sendOTPEndpoint => dotenv.env['SEND_OTP'] ?? '';
  static String get registerEndpoint => dotenv.env['REGISTER'] ?? '';
  static String get resetPasswordEndpoint => dotenv.env['RESET_PASSWORD'] ?? '';

  Future<Map<String, dynamic>> login(String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "countryCode": "855",
          "phone": phone,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(HoldToken.name, token);

        return {'success': true, 'message': 'Login successful', 'token': token};
      }

      return {'success': false, 'message': 'Login failed'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> sendOTP(String phone) async {
    try {
      final response = await http.post(
        Uri.parse(sendOTPEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"countryCode": "855", "phone": phone}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'OTP sent successfully'};
      }

      return {'success': false, 'message': 'Failed to send OTP'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> register(
    String phone,
    String password,
    String name,
    String otp,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(registerEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "countryCode": "855",
          "phone": phone,
          "password": password,
          "name": name,
          "otp": otp,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'Registration successful',
          'data': data,
        };
      }

      return {'success': false, 'message': 'Registration failed'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> sendOTPForReset(String phone) async {
    try {
      final response = await http.post(
        Uri.parse(sendOTPEndpoint), // Using same endpoint for reset OTP
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "countryCode": "855",
          "phone": phone,
          "type": "reset", // Add type to differentiate
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Reset OTP sent successfully'};
      }

      return {'success': false, 'message': 'Failed to send reset OTP'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> resetPassword(
    String phone,
    String otp,
    String newPassword,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(resetPasswordEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "countryCode": "855",
          "phone": phone,
          "otp": otp,
          "newPassword": newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Password reset successfully'};
      }

      return {'success': false, 'message': 'Failed to reset password'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
