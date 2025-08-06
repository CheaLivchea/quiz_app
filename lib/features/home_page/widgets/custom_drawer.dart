import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/features/auth/widgets/logout.dart';
import 'package:quiz_app/features/profile/screens/profile.dart';
import 'package:quiz_app/features/home_page/screens/QuizDashboard.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
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
                  leading: Icon(Icons.home, color: Color(0xFF6A3FC6)),
                  title: Text(
                    "Home",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Then navigate to Home screen or do any action
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Quizdashboard(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.history, color: Color(0xFF6A3FC6)),
                  title: Text(
                    "Quiz History",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.info, color: Color(0xFF6A3FC6)),
                  title: Text(
                    "About",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Color(0xFF6A3FC6)),
                  title: Text(
                    "Setting",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                ),
                SizedBox(height: 300),
                Logout(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
