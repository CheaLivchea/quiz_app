import 'package:flutter/material.dart';

class QuizDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ...existing code for dashboard quiz UI...
              ],
            ),
          ),
        ),
      ),
    );
  }
}
