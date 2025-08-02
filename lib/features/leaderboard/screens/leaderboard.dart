import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/features/leaderboard/widgets/profile_grade.dart';
import 'dart:math';

import 'package:quiz_app/features/leaderboard/widgets/profilebar.dart';

class Ranking extends StatelessWidget {
  const Ranking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              SizedBox(
                height: 20,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 40),
                  Text(
                    "Leaderboard",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Image.asset(
                    'assets/images/champion-removebg-preview.png',
                    scale: 12,
                  ),
                ],
              ),
              ProfileGrade(
                name: 'Peter Parker',
                imagePath: "assets/images/images-removebg-preview.png",
                grade: '1',
              ),
              SizedBox(height: 20),
              Transform.rotate(
                angle: 3 * pi / 100,
                child: Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Champion",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Profilebar(
                num: '2',
                name: "Natasha Romanoff",
                imagePath: "assets/images/images-removebg-preview.png",
                score: "78",
              ),
              SizedBox(height: 12),
              Profilebar(
                num: '3',
                name: "Steve Rogers",
                imagePath: "assets/images/images-removebg-preview.png",
                score: "75",
              ),
              SizedBox(height: 12),
              Profilebar(
                num: '4',
                name: "Bruce Banner",
                imagePath: "assets/images/images-removebg-preview.png",
                score: "73",
              ),
              SizedBox(height: 12),
              Profilebar(
                num: '5',
                name: "Wanda Maximoff",
                imagePath: "assets/images/images-removebg-preview.png",
                score: "71",
              ),
              SizedBox(height: 12),
              Profilebar(
                num: '6',
                name: "Clint Barton",
                imagePath: "assets/images/images-removebg-preview.png",
                score: "69",
              ),
              SizedBox(height: 12),
              Profilebar(
                num: '7',
                name: "Stephen Strange",
                imagePath: "assets/images/images-removebg-preview.png",
                score: "68",
              ),
              SizedBox(height: 12),
              Profilebar(
                num: '8',
                name: "Scott Lang",
                imagePath: "assets/images/images-removebg-preview.png",
                score: "66",
              ),
              SizedBox(height: 12),
              Profilebar(
                num: '9',
                name: "Carol Danvers",
                imagePath: "assets/images/images-removebg-preview.png",
                score: "64",
              ),
              SizedBox(height: 12),
              Profilebar(
                num: '10',
                name: "Nick Fury",
                imagePath: "assets/images/images-removebg-preview.png",
                score: "62",
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
