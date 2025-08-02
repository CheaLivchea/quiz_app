import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/constants/hold_token.dart';

class AuthService {
  static String get loginEndpoint => dotenv.env['LOGIN'] ?? '';

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
}
