import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnswerBtn extends StatelessWidget {
  final int index;
  final String title;
  final VoidCallback onTap;

  const AnswerBtn({
    super.key,
    required this.title,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String letter = String.fromCharCode(65 + index);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 330,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: Text(
            "$letter. ",
            style: GoogleFonts.poppins(
              fontSize: 23,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2B2B6C),
            ),
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 23,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2B2B6C),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
