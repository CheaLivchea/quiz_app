import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/features/result/screens/result.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/models/question.dart';
import '../services/category_service.dart';
import '../services/report_service.dart'; // Add this import
import '../models/category_detail_model.dart';
import '../widgets/answer_btn.dart';
import '../widgets/progress_bar.dart';

class QuizScreen extends StatefulWidget {
  final int categoryId;
  final String? categoryName;
  final String locale;
  
  const QuizScreen({
    super.key, 
    required this.categoryId,
    this.categoryName,
    this.locale = 'en',
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int currentIndex = 0;
  int score = 0;
  List<Map<String, dynamic>> summaryAnswer = [];
  CategoryDetail? categoryDetail;
  List<Question>? quizList;
  bool isLoad = false;
  String errorMessage = '';
  int? selectedAnswerIndex;
  bool isSubmittingReport = false; // Add loading state for report submission
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    // Reset all quiz state to ensure a fresh reload
    currentIndex = 0;
    score = 0;
    summaryAnswer = [];
    categoryDetail = null;
    quizList = null;
    isLoad = false;
    errorMessage = '';
    selectedAnswerIndex = null;
    isSubmittingReport = false;
    // Always fetch fresh data
    _fetchQuizData();
    
    // Initialize shimmer animation
    _shimmerController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOutSine,
    ));
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  void _fetchQuizData() async {
    setState(() {
      isLoad = false;
      errorMessage = '';
    });
    final result = await CategoryService().getCategoryDetail(widget.categoryId);
    print('📦 API Result: $result');
    if (result['success']) {
      setState(() {
        categoryDetail = result['data'] as CategoryDetail;
        quizList = categoryDetail?.questions;
        isLoad = true;
      });
    } else {
      // If API returned empty/null, retry once after a short delay
      if ((result['message'] ?? '').contains('empty or null body')) {
        print('🔁 Retrying category API after empty/null response...');
        await Future.delayed(const Duration(milliseconds: 500));
        final retryResult = await CategoryService().getCategoryDetail(widget.categoryId);
        print('📦 API Retry Result: $retryResult');
        if (retryResult['success']) {
          setState(() {
            categoryDetail = retryResult['data'] as CategoryDetail;
            quizList = categoryDetail?.questions;
            isLoad = true;
            errorMessage = '';
          });
          return;
        } else {
          setState(() {
            errorMessage = retryResult['message'] ?? 'Failed to load quiz data';
            isLoad = false;
          });
          return;
        }
      }
      setState(() {
        errorMessage = result['message'] ?? 'Failed to load quiz data';
        isLoad = false;
      });
    }
  }

  String _getQuestionText(Question question) {
    switch (widget.locale) {
      case 'zh':
        return question.questionZh.isNotEmpty ? question.questionZh : question.questionEn;
      case 'kh':
        return question.questionKh.isNotEmpty ? question.questionKh : question.questionEn;
      default:
        return question.questionEn;
    }
  }

  List<String> _getOptions(Question question) {
    switch (widget.locale) {
      case 'zh':
        return question.optionZh.isNotEmpty ? question.optionZh : question.optionEn;
      case 'kh':
        return question.optionKh.isNotEmpty ? question.optionKh : question.optionEn;
      default:
        return question.optionEn;
    }
  }

  // Add method to submit report to API
  Future<Map<String, dynamic>?> _submitReport() async {
    if (categoryDetail == null) return null;
    
    try {
      setState(() {
        isSubmittingReport = true;
      });

      final reportData = {
        "score": score,
        "totalQuestion": quizList!.length,
        "totalCorrect": score, // In this context, score represents correct answers
        "categoryEn": categoryDetail!.nameEn,
        "categoryKh": categoryDetail!.nameKh.isNotEmpty ? categoryDetail!.nameKh : categoryDetail!.nameEn,
        "categoryZh": categoryDetail!.nameZh.isNotEmpty ? categoryDetail!.nameZh : categoryDetail!.nameEn,
      };

      print('📤 Submitting report: $reportData');

      final result = await ReportService().submitReport(reportData);
      
      print('📥 Report submission result: $result');

      if (result['success']) {
        return result['data'];
      } else {
        print('❌ Report submission failed: ${result['message']}');
        // Show error but continue to result page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save report: ${result['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ Exception in _submitReport: $e');
      // Show error but continue to result page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save report: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isSubmittingReport = false;
      });
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Loading state with skeletonizer
    if (!isLoad) {
      return Scaffold(
        backgroundColor: Color(0xFF6A3FC6),
        appBar: AppBar(
          backgroundColor: Color(0xFF6A3FC6),
          elevation: 0,
          leading: BackButton(
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Quiz', style: GoogleFonts.poppins(fontSize: 20, color: Colors.white)),
          centerTitle: true,
        ),
        body: Skeletonizer(
          enabled: true,
          child: Column(
            children: [
              // Progress section skeleton
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  children: [
                    Text('Loading...', style: GoogleFonts.poppins(fontSize: 16)),
                    SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
              // Main content skeleton
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Question loading...', style: GoogleFonts.poppins(fontSize: 24)),
                            SizedBox(height: 12),
                            Text('...', style: GoogleFonts.poppins(fontSize: 20)),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        color: Colors.grey[200],
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    for (int i = 0; i < 4; i++) ...[
                                      if (i > 0) SizedBox(height: 12),
                                      Container(
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.grey[200]!,
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey[200],
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Text('...', style: GoogleFonts.poppins(fontSize: 16)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Error state
    if (errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: Color(0xFF6A3FC6),
        appBar: AppBar(
          backgroundColor: Color(0xFF6A3FC6),
          leading: BackButton(
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Quiz Error",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
                SizedBox(height: 20),
                Text(
                  'Oops! Something went wrong',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B2B6C),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _fetchQuizData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6A3FC6),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Retry'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Back'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    // No questions state
    if (quizList == null || quizList!.isEmpty) {
      return Scaffold(
        backgroundColor: Color(0xFF6A3FC6),
        appBar: AppBar(
          backgroundColor: Color(0xFF6A3FC6),
          leading: BackButton(
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            categoryDetail?.getName(widget.locale) ?? "Quiz",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.quiz_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 20),
                Text(
                  'No Questions Available',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B2B6C),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'This quiz category is currently empty.\nPlease try another category.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A3FC6),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Back to Categories'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Main quiz UI
    Question currentQuestion = quizList![currentIndex];
    double percentage = (currentIndex + 1) / quizList!.length;
    String questionText = _getQuestionText(currentQuestion);
    List<String> options = _getOptions(currentQuestion);
    
    // Update selected answer index when question changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedAnswerIndex == null || selectedAnswerIndex! >= options.length) {
        _updateSelectedAnswerForCurrentQuestion();
      }
    });

    return Scaffold(
      backgroundColor: Color(0xFF6A3FC6),
      appBar: AppBar(
        backgroundColor: Color(0xFF6A3FC6),
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          categoryDetail?.getName(widget.locale) ?? "Quiz",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress section
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              children: [
                Text(
                  "Question ${currentIndex + 1} of ${quizList!.length}",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 15),
                // Custom Progress Bar with better visibility
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.9),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Question section - Fixed height
                  Container(
                    height: 200,
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: AutoSizeText(
                        questionText,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B2B6C),
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 6,
                        minFontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // Divider
                  Container(
                    height: 1,
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFF6A3FC6).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Answer options section - Flexible height
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              itemCount: options.length,
                              separatorBuilder: (context, index) => SizedBox(height: 12),
                              itemBuilder: (context, i) {
                                bool isSelected = selectedAnswerIndex == i;
                                
                                return GestureDetector(
                                  onTap: () => _handleAnswerTap(i, currentQuestion, options),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isSelected 
                                          ? Color(0xFF6A3FC6).withOpacity(0.1)
                                          : Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? Color(0xFF6A3FC6)
                                            : Colors.grey[300]!,
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected
                                                ? Color(0xFF6A3FC6)
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: isSelected
                                                  ? Color(0xFF6A3FC6)
                                                  : Colors.grey[400]!,
                                              width: 2,
                                            ),
                                          ),
                                          child: isSelected
                                              ? Icon(
                                                  Icons.check_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                )
                                              : null,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: AutoSizeText(
                                            options[i],
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                              color: isSelected
                                                  ? Color(0xFF2B2B6C)
                                                  : Color(0xFF2B2B6C),
                                            ),
                                            maxLines: 3,
                                            minFontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Navigation buttons section
                  Container(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Row(
                      children: [
                        // Previous Button
                        Expanded(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: currentIndex > 0 ? _goToPreviousQuestion : null,
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                size: 18,
                              ),
                              label: Text(
                                "Previous",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: currentIndex > 0 
                                    ? Colors.grey[100] 
                                    : Colors.grey[50],
                                foregroundColor: currentIndex > 0 
                                    ? Color(0xFF6A3FC6) 
                                    : Colors.grey[400],
                                elevation: currentIndex > 0 ? 2 : 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(
                                    color: currentIndex > 0 
                                        ? Color(0xFF6A3FC6).withOpacity(0.3) 
                                        : Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 12),

                        // Next Button (show Finish on last question)
                        Expanded(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: (_isCurrentQuestionAnswered() && !isSubmittingReport) 
                                  ? (currentIndex < quizList!.length - 1 ? _goToNextQuestion : _finishQuiz)
                                  : null,
                              icon: isSubmittingReport 
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Icon(
                                      currentIndex < quizList!.length - 1 
                                          ? Icons.arrow_forward_rounded
                                          : Icons.flag_rounded,
                                      size: 18,
                                    ),
                              label: Text(
                                isSubmittingReport 
                                    ? "Submitting..."
                                    : (currentIndex < quizList!.length - 1 ? "Next" : "Finish"),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: (_isCurrentQuestionAnswered() && !isSubmittingReport)
                                    ? Color(0xFF6A3FC6)
                                    : Colors.grey[300],
                                foregroundColor: (_isCurrentQuestionAnswered() && !isSubmittingReport)
                                    ? Colors.white
                                    : Colors.grey[500],
                                elevation: (_isCurrentQuestionAnswered() && !isSubmittingReport) ? 3 : 0,
                                shadowColor: Color(0xFF6A3FC6).withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isCurrentQuestionAnswered() {
    return summaryAnswer.any(
      (item) => item["index"] == (currentIndex + 1).toString()
    );
  }

  void _goToPreviousQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        // Update selected answer for the previous question
        _updateSelectedAnswerForCurrentQuestion();
      });
    }
  }

  void _goToNextQuestion() {
    if (currentIndex < quizList!.length - 1) {
      setState(() {
        currentIndex++;
        // Update selected answer for the next question
        _updateSelectedAnswerForCurrentQuestion();
      });
    } else {
      _finishQuiz();
    }
  }

  void _updateSelectedAnswerForCurrentQuestion() {
    // Find if current question has been answered
    final answerData = summaryAnswer.firstWhere(
      (item) => item["index"] == (currentIndex + 1).toString(),
      orElse: () => {},
    );
    
    if (answerData.isNotEmpty) {
      // Find the index of the selected answer
      List<String> currentOptions = _getOptions(quizList![currentIndex]);
      selectedAnswerIndex = currentOptions.indexOf(answerData["userAnswer"]);
    } else {
      selectedAnswerIndex = null;
    }
  }

  void _finishQuiz() async {
    // Submit report to API first
    final reportResult = await _submitReport();
    
    // Navigate to result page with additional report data if available
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Result(
          score: score,
          summary: summaryAnswer,
          totalQuestions: quizList!.length,
          categoryName: categoryDetail?.getName(widget.locale) ?? "Quiz",
          categoryId: widget.categoryId,
          reportData: reportResult, // Pass the report data to Result page
        ),
      ),
    );
  }

  void _handleAnswerTap(int selectedIndex, Question currentQuestion, List<String> options) {
    final selectedAnswer = options[selectedIndex];
    final isCorrect = selectedAnswer == currentQuestion.answerCode;
    
    setState(() {
      selectedAnswerIndex = selectedIndex;
      
      // Check if this is a new answer or changing an existing one
      final existingIndex = summaryAnswer.indexWhere(
        (item) => item["index"] == (currentIndex + 1).toString()
      );
      
      bool wasAlreadyAnswered = existingIndex >= 0;
      bool wasCorrectBefore = wasAlreadyAnswered ? summaryAnswer[existingIndex]["isCorrect"] : false;
      
      // Update score
      if (wasAlreadyAnswered) {
        // Remove previous score if it was correct
        if (wasCorrectBefore) {
          score -= 1;
        }
      }
      
      // Add new score if correct
      if (isCorrect) {
        score += 1;
      }
      
      // Update or add answer data
      final answerData = {
        "question": _getQuestionText(currentQuestion),
        "userAnswer": selectedAnswer,
        "correctAnswer": currentQuestion.answerCode,
        "index": (currentIndex + 1).toString(),
        "isCorrect": isCorrect,
      };
      
      if (wasAlreadyAnswered) {
        summaryAnswer[existingIndex] = answerData;
      } else {
        summaryAnswer.add(answerData);
      }
    });
  }
}