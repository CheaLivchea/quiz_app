import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quiz_app/models/home_data.dart';
import 'package:quiz_app/features/auth/utils/token_manager.dart';

class HomeService {
  static String get getHomepageEndpoint => dotenv.env['GET_HOMEPAGE'] ?? '';

  // Fetch homepage data (categories, banners, promotions)
  Future<Map<String, dynamic>> getHomepageData() async {
    try {
      // Get the stored token
      final tokenManager = TokenManager();
      final token = await tokenManager.getToken();

      // Prepare headers
      Map<String, String> headers = {"Content-Type": "application/json"};
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }

      print('Fetching homepage data from: $getHomepageEndpoint');
      print('Headers: $headers');

      final response = await http.get(
        Uri.parse(getHomepageEndpoint),
        headers: headers,
      );

      print('Homepage API Response Status: ${response.statusCode}');
      print('Homepage API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // Check if categories exist and print debug info
        if (data['categories'] != null) {
          print('Categories found: ${data['categories'].length}');
        } else {
          print('No categories in response');
        }

        final homeData = HomeData.fromJson(data);
        return {'success': true, 'data': homeData};
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch homepage data',
        };
      }
    } catch (e) {
      print('Homepage API Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
