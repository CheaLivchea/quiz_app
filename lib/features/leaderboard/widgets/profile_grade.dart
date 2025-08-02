import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileGrade extends StatelessWidget {
  const ProfileGrade({
    super.key,
    required this.name,
    required this.imagePath,
    required this.grade,
  });
  final String name;
  final String imagePath;
  final String grade;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Color(0xC3F4F4F4),
                  border: Border.all(color: Color(0xFF6A3FC6), width: 2),
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
              SizedBox(
                width: 120,
                height: 120,
                child: ClipOval(
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Color(0xFF3DC4F6),
                    border: Border.all(color: Color(0xFF6A3FC6), width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    grade,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
