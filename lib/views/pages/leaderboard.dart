import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/views/widgets/profile_grade.dart';
import 'package:quiz_app/views/widgets/profilebar.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF6A3FC6),
        leading: FilledButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
          child: Icon(Icons.arrow_back_sharp, size: 25),
        ),
        title: Text(
          "Leaderboard",
          style: GoogleFonts.poppins(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 415,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A3FC6), Color(0xFF8D64D9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                // color: Color(0xFF6A3FC6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  ProfileGrade(
                    name: "Panha",
                    imagePath: "assets/images/maleprofile1.png",
                    grade: "1",
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ProfileGrade(
                        name: "Theary",
                        imagePath: "assets/images/femaleProfile.png",
                        grade: "2",
                      ),
                      ProfileGrade(
                        name: "Dalin",
                        imagePath: "assets/images/images-removebg-preview.png",
                        grade: "3",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Profilebar(
                    num: "4",
                    name: "Ying an",
                    imagePath: "assets/images/femaleProfile.png",
                    score: "90",
                  ),
                  SizedBox(height: 10),
                  Profilebar(
                    num: "5",
                    name: "Vicheka Mao",
                    imagePath: "assets/images/femaleProfile.png",
                    score: "84",
                  ),
                  SizedBox(height: 10),
                  Profilebar(
                    num: "6",
                    name: "Linda Heng",
                    imagePath: "assets/images/femaleProfile.png",
                    score: "78",
                  ),
                  SizedBox(height: 10),
                  Profilebar(
                    num: "7",
                    name: "Nary Phan",
                    imagePath: "assets/images/femaleProfile.png",
                    score: "70",
                  ),
                  SizedBox(height: 10),
                  Profilebar(
                    num: "8",
                    name: "Chea Livchea",
                    imagePath: "assets/images/my_profile.jpg",
                    score: "64",
                  ),
                  SizedBox(height: 10),
                  Profilebar(
                    num: "9",
                    name: "Ratha Chan",
                    imagePath: "assets/images/femaleProfile.png",
                    score: "60",
                  ),
                  SizedBox(height: 10),
                  Profilebar(
                    num: "10",
                    name: "Dara Lim",
                    imagePath: "assets/images/femaleProfile.png",
                    score: "55",
                  ),
                  SizedBox(height: 10),
                  Profilebar(
                    num: "11",
                    name: "Vicheka Mao",
                    imagePath: "assets/images/femaleProfile.png",
                    score: "50",
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
