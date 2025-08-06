import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/features/leaderboard/services/leaderboard_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>> _leaderboardData = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadLeaderboardData();
  }

  Future<void> _loadLeaderboardData() async {
    try {
      final result = await LeaderboardService.getTopPlayers();

      if (mounted) {
        setState(() {
          if (result['success'] == true) {
            _leaderboardData = List<Map<String, dynamic>>.from(
              result['data'] ?? [],
            );
            _errorMessage = '';
          } else {
            _errorMessage = result['message'] ?? 'Failed to load leaderboard';
            _leaderboardData = _getMockData(); // Fallback to mock data
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Network error occurred';
          _leaderboardData = _getMockData(); // Fallback to mock data
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> _getMockData() {
    return [
      {'name': 'Player 10', 'score': 1130, 'rank': 1},
      {'name': 'Sodina Bin', 'score': 419, 'rank': 2},
      {'name': 'LONGCELOT LoiHa...', 'score': 200, 'rank': 3},
      {'name': 'Alex Smith', 'score': 180, 'rank': 4},
      {'name': 'Emma Wilson', 'score': 160, 'rank': 5},
      {'name': 'David Brown', 'score': 140, 'rank': 6},
      {'name': 'Sarah Jones', 'score': 120, 'rank': 7},
      {'name': 'Mike Davis', 'score': 100, 'rank': 8},
      {'name': 'Lisa Taylor', 'score': 80, 'rank': 9},
      {'name': 'Tom Miller', 'score': 60, 'rank': 10},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF87CEEB).withOpacity(0.7),
              Color(0xFF6A3FC6).withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/dashboardquiz');
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Leaderboard',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            // Error message (if any)
            if (_errorMessage.isNotEmpty && !_isLoading)
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: GoogleFonts.poppins(
                          color: Colors.orange[800],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Top Performers Section
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'TOP PERFORMERS',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Podium Layout
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 2nd Place
                      _buildPodiumPlayer(
                        player: _leaderboardData.length > 1
                            ? _leaderboardData[1]
                            : null,
                        position: 2,
                        height: 80,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(width: 20),

                      // 1st Place (Higher)
                      _buildPodiumPlayer(
                        player: _leaderboardData.isNotEmpty
                            ? _leaderboardData[0]
                            : null,
                        position: 1,
                        height: 120,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 20),

                      // 3rd Place
                      _buildPodiumPlayer(
                        player: _leaderboardData.length > 2
                            ? _leaderboardData[2]
                            : null,
                        position: 3,
                        height: 60,
                        color: Colors.orange.shade400,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Leaderboard List Header
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6A3FC6).withOpacity(0.85),
                    Color(0xFF87CEEB).withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Text(
                    'Rank',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Player',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Score',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),

            // Leaderboard List
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: _isLoading
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Container(
                                  width: 60,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: _leaderboardData.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final player = _leaderboardData[index];
                          final rank = index + 1;
                          String imagePath =
                              'assets/images/images-removebg-preview.png';
                          final bool isTop5 = rank <= 5;
                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(
                                isTop5 ? 0.95 : 0.8,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isTop5
                                    ? Color(0xFF87CEEB)
                                    : Colors.transparent,
                                width: isTop5 ? 2 : 0,
                              ),
                            ),
                            child: Row(
                              children: [
                                if (isTop5)
                                  Icon(
                                    Icons.emoji_events,
                                    color: Color(0xFF87CEEB),
                                    size: 22,
                                  ),
                                if (isTop5) SizedBox(width: 8),
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF6A3FC6),
                                        Color(0xFF87CEEB),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$rank',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFF6A3FC6),
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      imagePath,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    player['name'] ?? 'Unknown Player',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF6A3FC6),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF87CEEB),
                                        Color(0xFF6A3FC6),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${player['score']} pt',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumPlayer({
    Map<String, dynamic>? player,
    required int position,
    required double height,
    required Color color,
  }) {
    return Column(
      children: [
        // Medal
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getMedalColor(position),
            shape: BoxShape.circle,
          ),
          child: Icon(_getMedalIcon(position), color: Colors.white, size: 24),
        ),
        SizedBox(height: 8),

        // Avatar
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/images-removebg-preview.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8),

        // Player Name
        Container(
          width: 80,
          child: Text(
            player?['name'] ?? 'Player $position',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Score
        Text(
          '${player?['score'] ?? 0}pt',
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 8),

        // Podium Base
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              '#$position',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getMedalColor(int position) {
    switch (position) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade400;
      case 3:
        return Colors.orange.shade400;
      default:
        return Colors.grey;
    }
  }

  IconData _getMedalIcon(int position) {
    switch (position) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.emoji_events;
      case 3:
        return Icons.emoji_events;
      default:
        return Icons.star;
    }
  }
}
