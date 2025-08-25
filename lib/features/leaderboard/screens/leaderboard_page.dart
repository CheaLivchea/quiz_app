import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/features/leaderboard/services/leaderboard_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeaderboardScreen extends StatefulWidget {
  final int? currentUserId; // Pass current user ID to identify them

  const LeaderboardScreen({super.key, this.currentUserId});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>> _leaderboardData = [];
  bool _isLoading = true;
  String _errorMessage = '';
  double _podiumOffset = 0.0;
  final double _maxPodiumOffset = -40.0;

  @override
  void initState() {
    super.initState();
    print('My user id is: ${widget.currentUserId}');
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
            _leaderboardData = LeaderboardService.getMockLeaderboard();
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Network error occurred';
          _leaderboardData = LeaderboardService.getMockLeaderboard();
          _isLoading = false;
        });
      }
    }
  }

  // Enhanced current user detection with better null safety
  bool _isCurrentUser(Map<String, dynamic> player) {
    if (widget.currentUserId == null) return false;

    // Check multiple possible ID fields and ensure type match
    final playerId = player['userId'] ?? player['id'] ?? player['user_id'];
    if (playerId == null) return false;
    int? playerIdInt;
    if (playerId is int) {
      playerIdInt = playerId;
    } else if (playerId is String) {
      playerIdInt = int.tryParse(playerId);
    }
    return playerIdInt != null && playerIdInt == widget.currentUserId;
  }

  String _getPlayerName(Map<String, dynamic> player) {
    final firstName = player['firstName'] ?? player['first_name'];
    final lastName = player['lastName'] ?? player['last_name'];
    final name = player['name'];

    if (name != null && name.toString().isNotEmpty) {
      return name.toString();
    } else if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName.toString();
    } else if (lastName != null) {
      return lastName.toString();
    } else {
      return 'Anonymous Player';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF6A3FC6),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
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
              SizedBox(height: 8),
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
              // Podium Section (Top 3)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildPodiumPlayer(
                          player: _leaderboardData.length > 1
                              ? _leaderboardData[1]
                              : null,
                          position: 2,
                          height: 80,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(width: 20),
                        _buildPodiumPlayer(
                          player: _leaderboardData.isNotEmpty
                              ? _leaderboardData[0]
                              : null,
                          position: 1,
                          height: 120,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 20),
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
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A3FC6), Color(0xFF87CEEB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      child: Text(
                        'Rank',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Player',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 70,
                      child: Text(
                        'Score',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              // Leaderboard List
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    itemCount: _isLoading ? 10 : _leaderboardData.length,
                    itemBuilder: (context, index) {
                      if (_isLoading) {
                        return _buildSkeletonCard();
                      }

                      final player = _leaderboardData[index];
                      print("player: $player");
                      final rank = index + 1;
                      final bool isCurrentUser = _isCurrentUser(player);
                      print("isCurrentUser: $isCurrentUser");
                      print(
                        "player id: ${player['id']}, isCurrentUser: ${_isCurrentUser(player)}",
                      );
                      final bool isTop3 = rank <= 3;
                      final bool isTop10 = rank <= 10;
                      String imagePath =
                          'assets/images/images-removebg-preview.png';

                      return Container(
                        margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? Color(0xFFFFD700).withOpacity(0.95)
                              : Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isCurrentUser
                                ? Color(0xFFFFD700)
                                : isTop3
                                ? Colors.amber.withOpacity(0.6)
                                : Color(0xFF87CEEB).withOpacity(0.3),
                            width: isCurrentUser ? 2.5 : (isTop3 ? 1.5 : 1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isCurrentUser
                                  ? Color(0xFFFFD700).withOpacity(0.3)
                                  : Colors.black.withOpacity(0.08),
                              blurRadius: isCurrentUser ? 12 : 6,
                              offset: Offset(0, isCurrentUser ? 4 : 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Rank Section
                              Container(
                                width: 50,
                                child: Row(
                                  children: [
                                    // Special icons for top positions
                                    if (isTop3) ...[
                                      Icon(
                                        Icons.emoji_events,
                                        color: _getRankColor(rank),
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                    ] else if (isCurrentUser) ...[
                                      Icon(
                                        Icons.person,
                                        color: Color(0xFF6A3FC6),
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                    ],
                                    // Rank number
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: isCurrentUser
                                              ? [
                                                  Color(0xFF6A3FC6),
                                                  Color(0xFF87CEEB),
                                                ]
                                              : isTop3
                                              ? [
                                                  _getRankColor(rank),
                                                  _getRankColor(
                                                    rank,
                                                  ).withOpacity(0.7),
                                                ]
                                              : [
                                                  Color(0xFF87CEEB),
                                                  Color(0xFF6A3FC6),
                                                ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$rank',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Player Info Section
                              Expanded(
                                child: Row(
                                  children: [
                                    // Avatar
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isCurrentUser
                                              ? Color(0xFF6A3FC6)
                                              : Color(0xFF87CEEB),
                                          width: 2.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          imagePath,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  color: Color(
                                                    0xFF87CEEB,
                                                  ).withOpacity(0.3),
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Color(0xFF6A3FC6),
                                                    size: 24,
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),

                                    // Name and indicators
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  _getPlayerName(player),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: isCurrentUser
                                                        ? FontWeight.w700
                                                        : FontWeight.w600,
                                                    color: isCurrentUser
                                                        ? Color(0xFF6A3FC6)
                                                        : Color(0xFF2C2C2C),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              // Current user indicator
                                              if (isCurrentUser) ...[
                                                SizedBox(width: 8),
                                              ],
                                            ],
                                          ),
                                          // Additional info for top players
                                          if (isTop3 && !isCurrentUser) ...[
                                            SizedBox(height: 2),
                                            Text(
                                              _getTopPlayerLabel(rank),
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: _getRankColor(rank),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Score Section
                              Container(
                                width: 70,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isCurrentUser
                                          ? [
                                              Color(0xFF6A3FC6),
                                              Color(0xFF87CEEB),
                                            ]
                                          : isTop3
                                          ? [
                                              _getRankColor(rank),
                                              _getRankColor(
                                                rank,
                                              ).withOpacity(0.8),
                                            ]
                                          : [
                                              Color(0xFF87CEEB),
                                              Color(0xFF6A3FC6),
                                            ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '${player['totalScore'] ?? player['score'] ?? 0}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          // Rank skeleton
          Container(
            width: 50,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Avatar skeleton
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          // Name skeleton
          Expanded(
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(width: 12),
          // Score skeleton
          Container(
            width: 70,
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTopPlayerLabel(int rank) {
    switch (rank) {
      case 1:
        return 'Champion';
      case 2:
        return 'Runner-up';
      case 3:
        return 'Third Place';
      default:
        return '';
    }
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade500;
      case 3:
        return Colors.orange.shade400;
      default:
        return Color(0xFF87CEEB);
    }
  }

  void _onScroll(double offset) {
    setState(() {
      _podiumOffset = (offset * -0.25).clamp(_maxPodiumOffset, 0.0);
    });
  }

  Widget _buildPodiumPlayer({
    Map<String, dynamic>? player,
    required int position,
    required double height,
    required Color color,
  }) {
    final bool isCurrentUser = player != null ? _isCurrentUser(player) : false;

    return Column(
      children: [
        // Medal
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getMedalColor(position),
            shape: BoxShape.circle,
            border: isCurrentUser
                ? Border.all(color: Color(0xFFFFD700), width: 3)
                : null,
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
            border: Border.all(
              color: isCurrentUser ? Color(0xFFFFD700) : color,
              width: isCurrentUser ? 4 : 3,
            ),
          ),
          child: Skeletonizer(
            enabled: _isLoading,
            child: ClipOval(
              child: Image.asset(
                'assets/images/images-removebg-preview.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),

        // Player Name
        Container(
          width: 80,
          child: Column(
            children: [
              Text(
                player != null ? _getPlayerName(player) : 'Player $position',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // "You" indicator for podium
              if (isCurrentUser) ...[
                SizedBox(height: 2),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'YOU',
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A3FC6),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Score
        Text(
          '${player?['totalScore'] ?? player?['score'] ?? 0}pt',
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
            color: isCurrentUser ? Color(0xFFFFD700) : color,
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
