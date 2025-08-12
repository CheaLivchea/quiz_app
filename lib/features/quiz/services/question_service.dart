import 'dart:io';
import 'package:http/io_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/constants/models/question.dart';
import '../../../core/state/store_token.dart';

class QuestionService {
  Future<List<Question>?> getQuestionsByCategory(int categoryId) async {
    try {
      final rawUrl = dotenv.env['GET_CATEGORY'] ?? '';
      final apiUrl = rawUrl.replaceAll('{ID}', categoryId.toString());
      var url = Uri.parse(apiUrl);

      print('[DEBUG] GET_CATEGORY URL: $apiUrl');
      print('[DEBUG] Token: ${token.value}');

      var httpClient = HttpClient();
      var client = IOClient(httpClient);
      var response = await client.get(
        url,
        headers: {'Authorization': 'Bearer ${token.value}'},
      );

      if (response.statusCode == 200) {
        print('Status code: ${response.statusCode}');
        print(response.body);

        // The response should contain a list of questions, adjust as needed
        return questionFromJson(response.body);
      } else {
        print('❌ Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
