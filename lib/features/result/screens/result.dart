import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/features/home_page/screens/QuizDashboard.dart';
import 'package:quiz_app/features/quiz/screens/quiz_screen.dart';
import 'package:quiz_app/features/result/widgets/summary_answer.dart';

class Result extends StatefulWidget {
  final int score;
  final List<Map<String, dynamic>> summary;
  final int totalQuestions;
  final String categoryName;
  final int categoryId;
  final Map<String, dynamic>? reportData;

  const Result({
    Key? key,
    required this.score,
    required this.summary,
    required this.totalQuestions,
    required this.categoryName,
    required this.categoryId,
    this.reportData,
  }) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> with TickerProviderStateMixin {
  // Ensure every summary item has categoryId for reload fallback
  List<Map<String, dynamic>> get _summaryWithCategoryId {
    return widget.summary.map((item) {
      return {
        ...item,
        'categoryId': widget.categoryId,
      };
    }).toList();
  }
  late AnimationController _scoreAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();

    // Debug print report data if available
    if (widget.reportData != null) {
      print('📊 Report ID: ${widget.reportData!['id']}');
      print('📊 Created at: ${widget.reportData!['createdAt']}');
      print('📊 User ID: ${widget.reportData!['userId']}');
    }

    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _scoreAnimationController,
        curve: Curves.elasticOut,
      ),
    );
    _cardAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _scoreAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  void _reloadQuiz() {
    final int catId = widget.categoryId;
    print('[DEBUG] Try Again pressed. categoryId: $catId');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          categoryId: catId,
          categoryName: widget.categoryName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int numCorrectAnswers = widget.score;
    final double percentage = (numCorrectAnswers / widget.totalQuestions) * 100;

    return Scaffold(
      backgroundColor: const Color(0xFF6A3FC6),
      body: SafeArea(
        child: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Quiz Results',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Report Information Card (if available)
                    if (widget.reportData != null) ...[
                      AnimatedBuilder(
                        animation: _cardAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _cardAnimation.value,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF4CAF50),
                                    Color(0xFF45A049),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF4CAF50,
                                    ).withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.cloud_done_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Results Saved Successfully!',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Report ID: ${widget.reportData!['id']}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white.withOpacity(
                                                  0.9,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Saved At',
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white.withOpacity(
                                                  0.8,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              _formatDateTime(
                                                widget.reportData!['createdAt'],
                                              ),
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (widget.reportData!['userId'] !=
                                            null)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'User ID',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                              Text(
                                                '${widget.reportData!['userId']}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],

                    // Score Display Card
                    AnimatedBuilder(
                      animation: _scoreAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scoreAnimation.value,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Success Icon with Animation
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4CAF50),
                                        Color(0xFF45A049),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF4CAF50,
                                        ).withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Fantastic Work!',
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF2D3748),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.categoryName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF718096),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                // Score Circle
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 140,
                                      height: 140,
                                      child: CircularProgressIndicator(
                                        value: percentage / 100,
                                        strokeWidth: 12,
                                        backgroundColor: const Color(
                                          0xFFE2E8F0,
                                        ),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              percentage >= 80
                                                  ? const Color(0xFF4CAF50)
                                                  : percentage >= 60
                                                  ? const Color(0xFFFF9800)
                                                  : const Color(0xFFF44336),
                                            ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '$numCorrectAnswers',
                                          style: GoogleFonts.poppins(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFF2D3748),
                                          ),
                                        ),
                                        Container(
                                          width: 30,
                                          height: 2,
                                          color: const Color(0xFF718096),
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                        ),
                                        Text(
                                          '${widget.totalQuestions}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF718096),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: percentage >= 80
                                        ? const Color(
                                            0xFF4CAF50,
                                          ).withOpacity(0.1)
                                        : percentage >= 60
                                        ? const Color(
                                            0xFFFF9800,
                                          ).withOpacity(0.1)
                                        : const Color(
                                            0xFFF44336,
                                          ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Text(
                                    '${percentage.toStringAsFixed(0)}% Correct',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: percentage >= 80
                                          ? const Color(0xFF4CAF50)
                                          : percentage >= 60
                                          ? const Color(0xFFFF9800)
                                          : const Color(0xFFF44336),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Review Answers Section
                    AnimatedBuilder(
                      animation: _cardAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _cardAnimation.value,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header with gradient background
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF667eea),
                                        Color(0xFF764ba2),
                                      ],
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.analytics_outlined,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Detailed Review',
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Check your answers below',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white.withOpacity(
                                                  0.8,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Summary stats bar
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF8FAFC),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _buildStatItem(
                                          'Correct',
                                          numCorrectAnswers.toString(),
                                          const Color(0xFF10B981),
                                          Icons.check_circle_outline,
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: const Color(0xFFE2E8F0),
                                      ),
                                      Expanded(
                                        child: _buildStatItem(
                                          'Incorrect',
                                          (widget.totalQuestions -
                                         
                                                  numCorrectAnswers)
                                              .toString(),
                                          const Color(0xFFEF4444),
                                          Icons.cancel_outlined,
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: const Color(0xFFE2E8F0),
                                      ),
                                      Expanded(
                                        child: _buildStatItem(
                                          'Accuracy',
                                          '${percentage.toStringAsFixed(0)}%',
                                          const Color(0xFF3B82F6),
                                          Icons.trending_up,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Questions list
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: _summaryWithCategoryId.asMap().entries.map((
                                      entry,
                                    ) {
                                      final index = entry.key;
                                      final element = entry.value;
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(
                                                0xFF667eea,
                                              ).withOpacity(0.1),
                                              const Color(
                                                0xFF764ba2,
                                              ).withOpacity(0.1),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: SummaryAnswer(
                                            question: element["question"],
                                            userAnswer: element["userAnswer"],
                                            userAnswerCode:
                                                element["userAnswerCode"] ?? '',
                                            answerCode:
                                                element["correctAnswer"] ?? '',
                                            answerText:
                                                element["correctAnswerText"] ??
                                                '',
                                            index: element["index"],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Action Buttons
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 24,
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF667eea),
                                    Color(0xFF764ba2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF667eea,
                                    ).withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: _reloadQuiz,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'TRY AGAIN',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 24,
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF9800),
                                    Color(0xFFFFB347),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFF9800,
                                    ).withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const Quizdashboard(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.list_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'EXIT',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for stats items
  Widget _buildStatItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  // Helper method to format datetime
  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) return 'Unknown';

    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        return '${difference.inHours}h ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
