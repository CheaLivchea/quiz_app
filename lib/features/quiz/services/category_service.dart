import 'dart:io';
import 'package:http/io_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/constants/models/question.dart';
import '../models/category_detail_model.dart';
import 'package:quiz_app/features/auth/utils/token_manager.dart';

class CategoryService {
  /// Get category details with questions by category ID
  Future<Map<String, dynamic>> getCategoryDetail(int categoryId) async {
    try {
      final rawUrl = dotenv.env['GET_CATEGORY'] ?? '';
      final apiUrl = rawUrl.replaceAll('{ID}', categoryId.toString());
      var url = Uri.parse(apiUrl);

      // Use TokenManager to get the token
      final tokenManager = TokenManager();
      final token = await tokenManager.getToken();

      print('[DEBUG] GET_CATEGORY URL: $apiUrl');
      print('[DEBUG] Token: $token');

      if (token == null || token.isEmpty) {
        print('❌ No token found. User must log in.');
        return {
          'success': false,
          'data': null,
          'message': 'No authentication token found. Please log in.',
        };
      }

      var httpClient = HttpClient();
      var client = IOClient(httpClient);
      var response = await client.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      print('[DEBUG] Response Status Code: ${response.statusCode}');
      print('[DEBUG] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.trim().isEmpty || response.body == 'null') {
          print('❌ API returned empty or null body');
          return {
            'success': false,
            'data': null,
            'message': 'API returned empty or null body for category detail',
          };
        }
        try {
          // Parse the category detail response
          final categoryDetail = categoryDetailFromJson(response.body);

          print('✅ Category loaded: \\${categoryDetail.nameEn}');
          print('✅ Questions count: \\${categoryDetail.questions.length}');

          return {
            'success': true,
            'data': categoryDetail,
            'message': 'Category details loaded successfully',
          };
        } catch (parseError) {
          print('❌ Parse Error: $parseError');
          return {
            'success': false,
            'data': null,
            'message': 'Failed to parse category data: $parseError',
          };
        }
      } else {
        print('❌ API Error: ${response.statusCode}');
        print('❌ Response Body: ${response.body}');
        return {
          'success': false,
          'data': null,
          'message': 'API Error: ${response.statusCode} - ${response.body}',
        };
      }
    } catch (e) {
      print('❌ Exception: $e');
      return {'success': false, 'data': null, 'message': 'Network error: $e'};
    }
  }

  /// Get only questions from a category (for backward compatibility)
  Future<List<Question>?> getQuestionsByCategory(int categoryId) async {
    final result = await getCategoryDetail(categoryId);

    if (result['success'] && result['data'] != null) {
      final CategoryDetail categoryDetail = result['data'];
      return categoryDetail.questions;
    }

    return null;
  }
}
