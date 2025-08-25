import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quiz_app/features/auth/utils/token_manager.dart';
import 'package:quiz_app/features/profile/services/user_service.dart';
import 'package:quiz_app/features/profile/models/user_data.dart';
class LeaderboardService {
  /// Print current user ID using UserService
  static Future<void> printCurrentUserId() async {
    final userService = UserService();
    final result = await userService.getUserInfo();
    if (result['success'] == true && result['data'] != null) {
      final user = result['data'] as UserData;
      print('Current user ID: ${user.id}');
    } else {
      print('Failed to get current user ID: ${result['message']}');
    }
  }

  static final String _topPlayerUrl = dotenv.env['TOP_PLAYER'] ?? '';

  /// Fetch top 10 players from the API
  static Future<Map<String, dynamic>> getTopPlayers() async {
    try {
      final tokenManager = TokenManager();

      // Check if token is valid first
      final isTokenValid = await tokenManager.isTokenValid();
      if (!isTokenValid) {
        print('❌ No valid authentication token found');
        return {
          'success': false,
          'message': 'Authentication required',
          'data': [],
        };
      }

      // Get the token
      final token = await tokenManager.getToken();

      if (token == null || token.isEmpty) {
        print('❌ Failed to retrieve authentication token');
        return {
          'success': false,
          'message': 'Authentication failed',
          'data': [],
        };
      }

      print('🔄 Fetching leaderboard from: $_topPlayerUrl');

      final response = await http.get(
        Uri.parse(_topPlayerUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📊 Leaderboard API Response Status: ${response.statusCode}');
      print('📊 Leaderboard API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Transform the API response to match our expected format
        final List<Map<String, dynamic>> transformedData = [];

        if (data is List) {
          for (int i = 0; i < data.length; i++) {
            final player = data[i];
            transformedData.add({
              'id': player['id']?.toString() ?? 'user_$i',
              'name': _getPlayerName(player),
              'score': _getPlayerScore(player),
              'rank': i + 1,
              'firstName': player['firstName'] ?? '',
              'lastName': player['lastName'] ?? '',
              'username': player['username'] ?? '',
              'phone': player['phone'] ?? '',
            });
          }
        }

        return {
          'success': true,
          'message': 'Leaderboard fetched successfully',
          'data': transformedData,
        };
      } else if (response.statusCode == 401) {
        print('❌ Authentication failed - token may be expired');
        return {
          'success': false,
          'message': 'Authentication failed',
          'data': [],
        };
      } else {
        print('❌ Failed to fetch leaderboard: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed to fetch leaderboard: ${response.statusCode}',
          'data': [],
        };
      }
    } catch (e) {
      print('❌ Error fetching leaderboard: $e');
      return {'success': false, 'message': 'Network error: $e', 'data': []};
    }
  }

  /// Extract player name from API response
  static String _getPlayerName(Map<String, dynamic> player) {
    // Try different possible name fields from the API
    if (player['firstName'] != null && player['lastName'] != null) {
      return '${player['firstName']} ${player['lastName']}'.trim();
    } else if (player['username'] != null && player['username'].isNotEmpty) {
      return player['username'];
    } else if (player['name'] != null && player['name'].isNotEmpty) {
      return player['name'];
    } else if (player['firstName'] != null) {
      return player['firstName'];
    } else {
      return 'Player ${player['id'] ?? 'Unknown'}';
    }
  }

  /// Extract player score from API response
  static int _getPlayerScore(Map<String, dynamic> player) {
    // Try different possible score fields from the API
    if (player['score'] != null) {
      return player['score'] is int
          ? player['score']
          : int.tryParse(player['score'].toString()) ?? 0;
    } else if (player['totalScore'] != null) {
      return player['totalScore'] is int
          ? player['totalScore']
          : int.tryParse(player['totalScore'].toString()) ?? 0;
    } else if (player['points'] != null) {
      return player['points'] is int
          ? player['points']
          : int.tryParse(player['points'].toString()) ?? 0;
    } else {
      return 0;
    }
  }

  /// Get mock data as fallback
  static List<Map<String, dynamic>> getMockLeaderboard() {
    return [
      {'id': 'user_456', 'name': 'Peter Parker', 'score': 85, 'rank': 1},
      {'id': 'user_789', 'name': 'Natasha Romanoff', 'score': 78, 'rank': 2},
      {'id': 'user_123', 'name': 'You', 'score': 75, 'rank': 3},
      {'id': 'user_321', 'name': 'Steve Rogers', 'score': 73, 'rank': 4},
      {'id': 'user_654', 'name': 'Bruce Banner', 'score': 71, 'rank': 5},
      {'id': 'user_987', 'name': 'Wanda Maximoff', 'score': 69, 'rank': 6},
      {'id': 'user_147', 'name': 'Clint Barton', 'score': 68, 'rank': 7},
      {'id': 'user_258', 'name': 'Stephen Strange', 'score': 66, 'rank': 8},
      {'id': 'user_369', 'name': 'Scott Lang', 'score': 64, 'rank': 9},
      {'id': 'user_741', 'name': 'Carol Danvers', 'score': 62, 'rank': 10},
    ];
  }
}
