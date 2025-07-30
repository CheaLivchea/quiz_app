import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/views/pages/login.dart';

import 'home_page.dart';

TextEditingController textController = TextEditingController();

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6A3FC6),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Row(children: [BackButton(color: Colors.white)]),
              ListTile(
                title: Text(
                  "Hey,\n Welcome\n Back",
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.messenger_outline,
                    color: Colors.white,
                  ),
                  hintText: 'Phone Number',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),

                  border: OutlineInputBorder(
                    // Border style
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ), // border color when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ), // border color when focused
                  ),
                ),
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),

              SizedBox(height: 30),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
                  hintText: 'Password',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),

                  border: OutlineInputBorder(
                    // Border style
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ), // border color when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ), // border color when focused
                  ),
                  suffixIcon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.white,
                  ),
                ),
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 30),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
                  hintText: 'Confirm Password',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),

                  border: OutlineInputBorder(
                    // Border style
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ), // border color when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ), // border color when focused
                  ),
                  suffixIcon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.white,
                  ),
                ),
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 50),
              FilledButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Sign up",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "or continue with",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 100),
                    Image.asset(
                      'assets/images/google-logo-removebg-preview.png',
                      height: 48,
                      width: 48,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Google",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  text: "Already have an account? ",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                  children: [
                    TextSpan(
                      text: "Login",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
