import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/hold_token.dart';

class TokenManager {
  Future<void> saveToken(String token, DateTime expiry) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(HoldToken.name, token);
    await prefs.setString('${HoldToken.name}_expiry', expiry.toIso8601String());
  }

  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(HoldToken.name);
    final expiry = prefs.getString('${HoldToken.name}_expiry');

    if (token == null || expiry == null) return false;

    final expiryDate = DateTime.parse(expiry);
    return DateTime.now().isBefore(expiryDate);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(HoldToken.name);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(HoldToken.name);
    await prefs.remove('${HoldToken.name}_expiry');
  }
}
