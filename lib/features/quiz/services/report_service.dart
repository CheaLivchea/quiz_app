import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_app/features/auth/utils/token_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReportService {
  String get reportEndpoint => dotenv.env['REPORT'] ?? '';

  Future<Map<String, dynamic>> submitReport(
    Map<String, dynamic> reportData,
  ) async {
    try {
      final endpoint = reportEndpoint;
      if (endpoint.isEmpty) {
        throw Exception('REPORT env variable is not set.');
      }
      print('🚀 Submitting report to: $endpoint');
      print('📦 Report data: $reportData');

      // Get token from TokenManager
      final token = await TokenManager().getToken();
      print('🔑 Token used for Authorization: $token');
      if (token == null) {
        print('❌ No auth token found');
        return {
          'success': false,
          'data': null,
          'message': 'No auth token found',
        };
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      print('📤 Request headers: $headers');

      final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: jsonEncode(reportData),
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
          'message': 'Report submitted successfully',
        };
      } else {
        // Handle different error status codes
        String errorMessage = 'Failed to submit report';

        try {
          final errorResponse = jsonDecode(response.body);
          errorMessage = errorResponse['message'] ?? errorMessage;
        } catch (e) {
          errorMessage = 'Server error: ${response.statusCode}';
        }

        return {'success': false, 'data': null, 'message': errorMessage};
      }
    } catch (e) {
      print('❌ Exception in submitReport: $e');
      return {'success': false, 'data': null, 'message': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>> getUserReports() async {
    try {
      final endpoint = reportEndpoint.replaceFirst('/submit', '/user');
      if (endpoint.isEmpty) {
        throw Exception('REPORT env variable is not set.');
      }
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          // Add authorization if needed
          // 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
          'message': 'Reports fetched successfully',
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Failed to fetch reports',
        };
      }
    } catch (e) {
      return {'success': false, 'data': null, 'message': 'Network error: $e'};
    }
  }
}
