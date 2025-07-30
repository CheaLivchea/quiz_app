import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/views/pages/home_page.dart';
import 'package:quiz_app/views/pages/loading_page.dart';
import 'package:quiz_app/views/pages/result.dart';

import '../../constants/quiz_data.dart';
import '../../models/question.dart';
import '../../services/question_service.dart';
import '../widgets/answer_btn.dart';
import '../widgets/progress_bar.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  int score = 0;
  List<Map<String, dynamic>> summaryAnswer = [];
  List<Question>? quizList;
  bool isLoad = false;
  @override
  void initState() {
    super.initState();
    print("the function tigger");
    getData();
  }

  getData() async {
    quizList = await QuestionService().getQuestions();

    print('📦 quizList: $quizList');

    if (quizList != null) {
      setState(() {
        isLoad = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoad) {
      return Scaffold(
        backgroundColor: Color(0xFF6A3FC6),
        body: Center(child: Lottie.asset("assets/lottie/loadingbox.json")),
      );
    }
    Question currentQuestion = quizList![currentIndex];
    print('Question ${currentQuestion.questionEn}');
    double percentage = currentIndex / quizList!.length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6A3FC6),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: Text(
          "Quizzes",
          style: GoogleFonts.poppins(
            fontSize: 35,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 30, 8, 10),
              child: Container(
                height: 670,
                width: 370,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Text(
                        "Question ${currentIndex + 1} of ${quizList!.length}",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6666D8),
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        alignment: Alignment.center,
                        height: 140,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: AutoSizeText(
                          currentQuestion.questionEn,
                          style: GoogleFonts.poppins(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B2B6C),
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          minFontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(height: 20),

                      Column(
                        children: [
                          for (
                            int i = 0;
                            i < currentQuestion.optionEn.length;
                            i++
                          ) ...[
                            SizedBox(height: 20),
                            AnswerBtn(
                              title: currentQuestion.optionEn[i],
                              index: i,
                              onTap: () {
                                setState(() {
                                  if (currentIndex < quizList!.length - 1) {
                                    if (currentQuestion.optionEn[i] ==
                                        currentQuestion.answerCode) {
                                      score += 1;
                                    }
                                    summaryAnswer.add({
                                      "question": currentQuestion.questionEn,
                                      "userAnswer": currentQuestion.optionEn[i],
                                      "correctAnswer":
                                          currentQuestion.answerCode,
                                      "index": (currentIndex + 1).toString(),
                                    });
                                    currentIndex++;
                                  } else {
                                    summaryAnswer.add({
                                      "question": currentQuestion.questionEn,
                                      "userAnswer": currentQuestion.optionEn[i],
                                      "correctAnswer":
                                          currentQuestion.answerCode,
                                      "index": (currentIndex + 1).toString(),
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Result(
                                          score: score,
                                          summary: summaryAnswer,
                                        ),
                                      ),
                                    );
                                  }
                                });
                              },
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 30),
                      ProgressBar(
                        width: 300,
                        height: 20,
                        percentage: percentage,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (currentIndex > 0) {
                  setState(() {
                    currentIndex--;
                  });
                }
              },
              child: Text("Previous"),
            ),
          ],
        ),
      ),
    );
  }
}
