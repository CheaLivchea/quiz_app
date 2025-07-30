import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profilebar extends StatefulWidget {
  const Profilebar({
    super.key,
    required this.num,
    required this.name,
    required this.imagePath,
    required this.score,
  });

  final String num;
  final String name;
  final String imagePath;
  final String score;

  @override
  State<Profilebar> createState() => _ProfilebarState();
}

class _ProfilebarState extends State<Profilebar> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: isPressed
              ? Color(0xFFDAD2F5)
              : Color(0xFFE9E5F6), // light soft background
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Color(0x77674F4F),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              widget.num,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6A3FC6), // theme purple
              ),
            ),
            SizedBox(width: 20),
            ClipOval(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFFD7CFF2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(widget.imagePath, fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 20),
            Text(
              widget.name,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            Container(
              width: 50,
              height: 30,
              decoration: BoxDecoration(
                color: Color(0x773398DA),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.score}pt",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF444444),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
