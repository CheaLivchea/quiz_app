import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/features/quiz/services/question_service.dart';
import 'package:quiz_app/features/quiz/screens/quiz_screen.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

void loadQuizData() async {
  await Future.delayed(Duration(seconds: 2));
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6A3FC6),
      body: Center(child: Lottie.asset("assets/lottie/loadingbox.json")),
    );
  }
}
