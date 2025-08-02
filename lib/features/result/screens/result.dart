import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/features/result/widgets/summary_answer.dart';
import 'package:quiz_app/features/home_page/screens/home_page.dart';

class Result extends StatefulWidget {
  const Result({super.key, required this.score, required this.summary});
  final int score;
  final List<Map<String, dynamic>> summary;
  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              Stack(
                children: [
                  Image.asset('assets/images/result.png', height: 450),
                  Positioned(
                    top: 230,
                    left: 95,
                    child: RichText(
                      textAlign: TextAlign
                          .center, // center the whole text horizontally
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF0F0F10),
                          height: 1.3,
                        ),
                        children: [
                          TextSpan(text: "Your Score\n"), // normal style
                          TextSpan(
                            text: widget.score.toString(),
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          TextSpan(text: " out "),
                          TextSpan(
                            text: "100\n",
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          TextSpan(text: "correctly"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Container(
                width: 380,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Results",
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF132650),
                      ),
                    ),
                    SizedBox(height: 15),
                    ...widget.summary.map(
                      (element) => SummaryAnswer(
                        question: element["question"],
                        userAnswer: element["userAnswer"],
                        answer: element["correctAnswer"],
                        index: element["index"],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 275,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4DE33C),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        },
                        child: Text(
                          "TRY AGAIN",
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
