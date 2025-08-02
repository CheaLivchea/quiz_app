import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/features/profile/screens/profile.dart';
import 'package:quiz_app/features/quiz/screens/quiz_screen.dart';
import 'package:quiz_app/features/leaderboard/screens/leaderboard.dart';
import 'package:quiz_app/features/welcome/screens/welcome_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6A3FC6),
      appBar: AppBar(
        backgroundColor: Color(0xFF6A3FC6),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),

        title: Text(
          "Qiuzzes",
          style: GoogleFonts.poppins(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFFE0D7F8),
        width: 355,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
              child: Container(
                height: 180,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16, 40, 16, 10),
                decoration: BoxDecoration(color: Color(0xFF6A3FC6)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 15),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: SizedBox(
                        height: 80,
                        child: Image.asset("assets/images/my_profile.jpg"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 28),
                        Text(
                          "Livchea",
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        Text(
                          "Chealivchea@gmail.com",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.home, color: Color(0xFF4B4B6A)),
                    title: Text(
                      "Home",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B4B6A),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      // Then navigate to Home screen or do any action
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.history, color: Color(0xFF4B4B6A)),
                    title: Text(
                      "Quiz History",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B4B6A),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.leaderboard, color: Color(0xFF4B4B6A)),
                    title: Text(
                      "Leaderboard",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B4B6A),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Ranking(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info, color: Color(0xFF4B4B6A)),
                    title: Text(
                      "About",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B4B6A),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: Color(0xFF4B4B6A)),
                    title: Text(
                      "Setting",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B4B6A),
                      ),
                    ),
                  ),
                  SizedBox(height: 300),
                  ListTile(
                    leading: Icon(Icons.logout_sharp, color: Color(0xFF4B4B6A)),
                    title: Text(
                      "Logout",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF282433),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomePage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Image.asset('assets/images/home.png'),
            SizedBox(height: 60),
            Container(
              height: 225,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    RichText(
                      textAlign: TextAlign
                          .center, // center the whole text horizontally
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF21217C),
                          height: 1.2,
                        ),
                        children: [
                          TextSpan(text: "Welcome to\n"), // normal style
                          TextSpan(text: "our quiz!"),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: 250,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QuizScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5BE155),
                        ),
                        child: Text(
                          "START QUIZ",
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
