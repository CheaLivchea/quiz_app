import 'dart:io';
import 'package:http/io_client.dart';
import '../models/question.dart';
import '../notifier/store_token.dart';

class QuestionService {
  Future<List<Question>?> getQuestions() async {
    try {
      var url = Uri.parse(
        'https://quiz-api.camtech-dev.online/api/questions/list',
      );

      var httpClient = HttpClient();
      var client = IOClient(httpClient);
      print('From quize: ${token.value}');
      var response = await client.get(
        url,
        headers: {'Authorization': 'Bearer ${token.value}'},
      );

      if (response.statusCode == 200) {
        print('Status code: ${response.statusCode}');
        print(response.body);

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
