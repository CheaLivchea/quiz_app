import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryAnswer extends StatelessWidget {
  const SummaryAnswer({
    super.key,
    required this.question,
    required this.userAnswer,
    required this.answer,
    required this.index,
  });
  final String question;
  final String userAnswer;
  final String answer;
  final String index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,

      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$index. $question",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: Text(
                  "Your Answer: $userAnswer",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.visible,
                  maxLines: 2,
                ),
              ),
              SizedBox(width: 8),
              userAnswer == answer
                  ? Icon(Icons.check, color: Colors.green)
                  : Icon(Icons.close, color: Colors.red),
            ],
          ),

          SizedBox(height: 10),
          Text(
            "Correct Answer: $answer",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Divider(thickness: 2.0),
        ],
      ),
    );
  }
}
