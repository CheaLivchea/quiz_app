import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/constants/hold_token.dart';
import 'package:quiz_app/views/pages/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../notifier/store_token.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static const String apiUrl =
      "https://quiz-api.camtech-dev.online/api/auth/login";

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> login() async {
    Uri uri = Uri.parse(apiUrl);

    try {
      var res = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "countryCode": "855",
          "phone": phoneNumberController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      if (!mounted) return false;

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final token = data['token'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(HoldToken.name, token);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login successfully!")));
        return true;
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login failed!")));
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    // getToken();
  }

  // void getToken() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final savedToken = prefs.getString(HoldToken.name);
  //   if (savedToken != null) {
  //     token.value = savedToken;
  //     print('Token restored: $savedToken');
  //   } else {
  //     print(' No token found in SharedPreferences');
  //   }
  // }

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
                controller: phoneNumberController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone_outlined, color: Colors.white),
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
                controller: passwordController,
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
                obscureText: true,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot password?",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              FilledButton(
                onPressed: () async {
                  print("Button press");
                  bool success = await login();
                  print("It works");
                  if (!mounted) return;
                  if (success) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                },

                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      // For tap/press feedback
                      return Colors.grey.shade400; // Example pressed color
                    }

                    return Colors.white; // Default color
                  }),
                  minimumSize: WidgetStateProperty.all(
                    const Size(double.infinity, 50),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: Text(
                  "Login",
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
                  text: "Don't have an account? ",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
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
