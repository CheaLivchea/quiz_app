import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/features/leaderboard/widgets/profile_grade.dart';
import 'dart:math';

import 'package:quiz_app/features/leaderboard/widgets/profilebar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Ranking extends StatefulWidget {
  const Ranking({super.key});

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  bool _isLoading = true;
  List<Map<String, String>> leaderboard = [];

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));
    leaderboard = [
      {"num": "1", "name": "Peter Parker", "score": "80"},
      {"num": "2", "name": "Natasha Romanoff", "score": "78"},
      {"num": "3", "name": "Steve Rogers", "score": "75"},
      {"num": "4", "name": "Bruce Banner", "score": "73"},
      {"num": "5", "name": "Wanda Maximoff", "score": "71"},
      {"num": "6", "name": "Clint Barton", "score": "69"},
      {"num": "7", "name": "Stephen Strange", "score": "68"},
      {"num": "8", "name": "Scott Lang", "score": "66"},
      {"num": "9", "name": "Carol Danvers", "score": "64"},
      {"num": "10", "name": "Nick Fury", "score": "62"},
    ];
    setState(() {
      _isLoading = false;
    });
  }

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
              _isLoading
                  ? Skeletonizer(
                      child: Column(
                        children: List.generate(
                          10,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: leaderboard
                          .map(
                            (item) => Profilebar(
                              num: item["num"]!,
                              name: item["name"]!,
                              imagePath:
                                  "assets/images/images-removebg-preview.png",
                              score: item["score"]!,
                            ),
                          )
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
